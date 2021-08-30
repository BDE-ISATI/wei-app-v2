import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isati_integration/services/solo_validations_service.dart';
import 'package:isati_integration/src/pages/player/solo_challenges_page/solo_challenge_details_page/submit_solo_challenge_page/widgets/submit_solo_challenge_add_button.dart';
import 'package:isati_integration/src/pages/player/solo_challenges_page/solo_challenge_details_page/submit_solo_challenge_page/widgets/submit_solo_challenge_media_button.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/solo_challenge_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_app_bar.dart';
import 'package:isati_integration/src/shared/widgets/general/is_button.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/utils/image_compresser/is_image_compress.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';
import 'package:video_compress/video_compress.dart';

class SubmitSoloChallengePage extends StatefulWidget {
  @override
  State<SubmitSoloChallengePage> createState() => _SubmitSoloChallengePageState();
}

class _SubmitSoloChallengePageState extends State<SubmitSoloChallengePage> {
  final List<String> _medias = [];

  bool _isFileLoading = false;
  bool _isHttpLoading = false;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IsAppBar(
        title: Text("Envoyer des preuves"),
      ),
      body: Padding(
        padding: ScreenUtils.instance.defaultPadding,
        child: _isFileLoading ?
          const Center(child: CircularProgressIndicator(),) : 
          Column(
            mainAxisAlignment: _isHttpLoading ? MainAxisAlignment.center : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isHttpLoading) ...{
                const Center(child: CircularProgressIndicator(),),
                const SizedBox(height: 8.0,),
                const Text(
                  "NE PAS FERMER ! Vos preuves sont en cours d'envoie, "
                  "cela prend plus ou moins de temps en fonctions de la "
                  "taille de vos fichier et de votre connexion internet",
                  textAlign: TextAlign.center,
                ),
              }
              else ...{
                if (_errorMessage.isNotEmpty) ... {
                  IsStatusMessage(
                    title: "Erreur lors de l'envoie",
                    message: "Impossible d'envoyer les preuves : $_errorMessage. N'hésite pas à contacter un administrateur si le problème persiste.",
                  )
                },
                Expanded(
                  child: GridView.count(
                    crossAxisCount: ScreenUtils.instance.responsiveCrossAxisCount(context),
                    children: [
                      for (final media in _medias) 
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SubmitSoloChallengeMediaButton(
                            media: media,
                            onRemove: () {
                              setState(() {
                                _medias.remove(media);
                              });
                            },
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SubmitSoloChallengeAddButton(
                          onPressed: _onAddMedia,
                        ),
                      )
                    ], 
                  ),
                ),
                IsButton(
                  text: "Envoyer",
                  onPressed: _onSubmitProofs,
                )
              }
            ],
          ),
      ),
    );
  }

  Future _onAddMedia() async {
    setState(() {
      _isFileLoading = true;
      _isHttpLoading = false;
    });

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.media
    );

    if (result != null) {
      final Set<String> videosType = { "webm","wmv","mpeg","mkv","mp4","avi","mov","flv" };

      for (final file in result.files) {
        if (videosType.contains(file.extension)) {
          final bytes = await _processVideo(file);

          if (bytes == null) {
            continue;
          }

          _medias.add(base64Encode(utf8.encode("type=video") + bytes));
        }
        else {
          final bytes = await _processImage(file);
          _medias.add(base64Encode(bytes));
        }
      }
    }

    setState(() {
      _isFileLoading = false;
      _isHttpLoading = false;
    });
  }

  Future<Uint8List?> _processVideo(PlatformFile platformFile) async {
    Uint8List? fileBytes;

    if (kIsWeb) {
      if (platformFile.size > 60*1024*1024) {
        await showDialog<void>(
          context: context, 
          builder: (context) => AlertDialog(
            title: const Text("Impossible d'importer cette vidéo"),
            content: const Text("Vous ne pouvez pas importer cette vidéo car elle est trop lourde. Essayer de réduire sa "
                                "taille en ligne avec des outils comme https://www.freeconvert.com/video-compressor"),
            actions: [
              TextButton( 
                onPressed: () { Navigator.of(context).pop(); },
                child: const Text("Ok"),
              )
            ],
          )
        );

        return null;
      }

      fileBytes = platformFile.bytes;
    }
    else {
      final File file = File(platformFile.path!);
      
      final MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        file.path, 
      );

      fileBytes = await mediaInfo!.file!.readAsBytes();
    }

    return fileBytes!;
  }

  Future<Uint8List> _processImage(PlatformFile platformFile) async {
    Uint8List? fileBytes;
    if (kIsWeb) {
      fileBytes = platformFile.bytes;
    }
    else {
      final File file = File(platformFile.path!);
      fileBytes = await file.readAsBytes();
    }

    return IsImageCompress.instance.compress(fileBytes!);
  }

  Future _onSubmitProofs() async {
    setState(() {
      _isHttpLoading = true;
      _isFileLoading = false;
      _errorMessage = "";
    });

    try {
      final challengeStore = Provider.of<SoloChallengeStore>(context, listen: false);
      final appUserStore = Provider.of<AppUserStore>(context, listen: false);

      await SoloValidationsService.instance.submitValidation(
        challengeStore.challenge.id!, 
        _medias, 
        authorization: appUserStore.authenticationHeader
      );

      Navigator.of(context).pop(true);
    }
    on PlatformException catch(e) {
      setState(() {
        _isHttpLoading = false; 
        _isFileLoading = false;
        _errorMessage = "Impossible de les preuves : ${e.code} ; ${e.message}";
      });
    }
    on Exception catch(e) {
      setState(() {
        _isHttpLoading = false;
        _isFileLoading = false;
        _errorMessage = "Une erreur inconnue s'est produite : $e";
      });
    }
  }
}
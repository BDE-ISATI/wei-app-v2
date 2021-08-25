import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:isati_integration/src/pages/player/solo_challenges_page/solo_challenge_details_page/submit_solo_challenge_page/widgets/submit_solo_challenge_add_button.dart';
import 'package:isati_integration/src/pages/player/solo_challenges_page/solo_challenge_details_page/submit_solo_challenge_page/widgets/submit_solo_challenge_media_button.dart';
import 'package:isati_integration/src/shared/widgets/general/is_app_bar.dart';
import 'package:isati_integration/src/shared/widgets/general/is_button.dart';
import 'package:isati_integration/utils/screen_utils.dart';

class SubmitSoloChallengePage extends StatefulWidget {
  @override
  State<SubmitSoloChallengePage> createState() => _SubmitSoloChallengePageState();
}

class _SubmitSoloChallengePageState extends State<SubmitSoloChallengePage> {
  final List<String> _medias = [];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IsAppBar(
        title: Text("Envoyer des preuve"),
      ),
      body: Padding(
        padding: ScreenUtils.instance.defaultPadding,
        child: _isLoading ?
          const Center(child: CircularProgressIndicator(),) : 
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
            ],
          ),
      ),
    );
  }

  Future _onAddMedia() async {
    setState(() {
      _isLoading = true;
    });

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image
    );

    if (result != null) {
      final List<File> files = result.paths.map((path) => File(path!)).toList();

      for (final file in files) {
        final String bytes = base64Encode(await file.readAsBytes());
        _medias.add(bytes);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future _onSubmitProofs() async {

  }
}
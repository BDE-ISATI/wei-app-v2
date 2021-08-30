import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isati_integration/src/shared/widgets/general/is_icon_button.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:video_player/video_player.dart';

class SubmitSoloChallengeMediaButton extends StatefulWidget {
  const SubmitSoloChallengeMediaButton({
    Key? key, 
    required this.media,
    required this.onRemove,
  }) : super(key: key);

  final String media;

  final Function() onRemove;

  @override
  _SubmitSoloChallengeMediaButtonState createState() => _SubmitSoloChallengeMediaButtonState();
}

class _SubmitSoloChallengeMediaButtonState extends State<SubmitSoloChallengeMediaButton> {
  VideoPlayerController? _videoController;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: brightenColor(colorPrimary, percent: 20),
              height: 200,
              child: Builder(
                builder: (context) {
                  final bytes = base64Decode(widget.media);
                  final utf8bytes = utf8.encode("type=video");

                  if (bytes[0] == utf8bytes[0] &&
                      bytes[1] == utf8bytes[1] &&
                      bytes[2] == utf8bytes[2] &&
                      bytes[3] == utf8bytes[3] &&
                      bytes[4] == utf8bytes[4] &&
                      bytes[5] == utf8bytes[5] &&
                      bytes[6] == utf8bytes[6] &&
                      bytes[7] == utf8bytes[7] &&
                      bytes[8] == utf8bytes[8] &&
                      bytes[9] == utf8bytes[9]) {
                    final videoBytes = bytes.sublist(10);

                    return _buildVideoPlayer(videoBytes);
                  }

                  return Image.memory(
                    base64Decode(widget.media),
                    fit: BoxFit.cover,
                  );
                }
              ),
            )
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IsIconButton(
              backgroundColor: colorError,
              onPressed: widget.onRemove,
              icon: Icons.remove,
            ),
          )
        ],
      )
    );
  }

  Widget _buildVideoPlayer(Uint8List videoBytes) {
    return FutureBuilder(
      future: _getVideoController(videoBytes),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Icon(Icons.error),);
          }

          return VideoPlayer(_videoController!);
        }

        return const Center(child: CircularProgressIndicator(),);
      },
    );
  }

  Future<VideoPlayerController> _getVideoController(Uint8List videoBytes) async {
    if (_videoController != null) {
      return _videoController!;
    }

    if (kIsWeb) {
      final blob = html.Blob(<Uint8List>[videoBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      _videoController = VideoPlayerController.network(url);
    }
    else {
      final String path = (await getTemporaryDirectory()).path;
      final File video = File("$path/${DateTime.now().microsecondsSinceEpoch}");
      
      await video.writeAsBytes(videoBytes);

      _videoController = VideoPlayerController.file(video);
    }

    await _videoController!.initialize();

    return _videoController!;
  }
}
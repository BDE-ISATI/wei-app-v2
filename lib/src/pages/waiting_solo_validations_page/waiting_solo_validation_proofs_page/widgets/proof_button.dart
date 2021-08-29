import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class ProofButton extends StatefulWidget {
  const ProofButton({
    Key? key, 
    required this.media,
  }) : super(key: key);

  final String media;

  @override
  _ProofButtonState createState() => _ProofButtonState();
}

class _ProofButtonState extends State<ProofButton> {
  VideoPlayerController? _videoController;

  @override
  Widget build(BuildContext context) {
    final bytes = base64Decode(widget.media); 
    final utf8bytes = utf8.encode("type=video");
    final bool isVideo = bytes[0] == utf8bytes[0] &&
                         bytes[1] == utf8bytes[1] &&
                         bytes[2] == utf8bytes[2] &&
                         bytes[3] == utf8bytes[3] &&
                         bytes[4] == utf8bytes[4] &&
                         bytes[5] == utf8bytes[5] &&
                         bytes[6] == utf8bytes[6] &&
                         bytes[7] == utf8bytes[7] &&
                         bytes[8] == utf8bytes[8] &&
                         bytes[9] == utf8bytes[9];
    return InkWell(
      onTap: () async {
        await showDialog<void>(
          context: context,
          builder: (context) {
            if (isVideo && _videoController != null) {
              return _buildVideoDialog();
            }

            if (isVideo && _videoController == null) {
              return const Dialog(
                child: Text("Attendez que la vidéo soit complètement chargé !"),
              );
            }
            
            return _buildImageDialog(); 
          }
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          color: brightenColor(colorPrimary, percent: 20),
          height: 200,
          child: !isVideo ? 
            Image.memory(
              base64Decode(widget.media),
              fit: BoxFit.cover,
            ) : 
            FutureBuilder(
              future: _getVideoController(bytes.sublist(10)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(child: Icon(Icons.error),);
                  }

                  return const Center(child: Icon(Icons.videocam, size: 48,));
                  // return IgnorePointer(
                  //   child: VideoPlayer(_videoController!)
                  // );
                }

                return const Center(child: CircularProgressIndicator(),);
              },
            )
        )
      ),
    );
  }

  Widget _buildVideoDialog() {
    if (_videoController == null) {
      return const Dialog(
        child: Icon(Icons.error),
      );
    }

    _videoController!.play();

    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: VideoPlayer(_videoController!),
    );
  }

  Widget _buildImageDialog() {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Image.memory(base64Decode(widget.media)),
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
      final File video = File("$path/${UniqueKey()}");
      
      await video.writeAsBytes(videoBytes);

      _videoController = VideoPlayerController.file(video);
    }

    await _videoController!.initialize();

    return _videoController!;
  }
}
import 'package:flutter/material.dart';
import 'package:isati_integration/models/is_image.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:provider/provider.dart';

class IsImageWidget extends StatelessWidget {
  const IsImageWidget({Key
    ? key, 
    required this.source,
    this.defaultPadding = const EdgeInsets.all(20.0),
    this.width,
    this.height,
    this.fit
  }) : super(key: key);

  final IsImage source;

  final EdgeInsets defaultPadding;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppUserStore>(
      builder: (context, appUserStore, child) {
        return FutureBuilder(
          future: source.loadImageFromSource(appUserStore.authenticationHeader),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return _buildEmptyImage(child: const Center(child: Icon(Icons.error),));
              }

              if (!snapshot.hasData) {
                return _buildEmptyImage(child: Image.asset("assets/images/logo_white.png"), brighter: false);
              }

              return Image(
                image: snapshot.data as MemoryImage,
                width: width,
                height: height,
                fit: fit,
              );
            }

            return _buildEmptyImage(child: const Center(child: CircularProgressIndicator(),));
          },
        );
      }
    );
  }

  Widget _buildEmptyImage({required Widget child, bool brighter = true}) {
    return Container(
      color: brightenColor(colorPrimary, percent: brighter ? 85 : 10),
      padding: defaultPadding,
      width: width,
      height: height,
      child: child,
    );
  }
}
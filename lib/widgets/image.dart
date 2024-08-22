import 'package:flutter/material.dart';

class ImageToTransparent extends StatelessWidget {
  final String name;
  final double height;
  const ImageToTransparent(this.name, {super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.transparent],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: Image.asset(
        name,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}

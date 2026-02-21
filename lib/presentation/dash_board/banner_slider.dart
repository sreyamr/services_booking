import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class BannerImage extends StatelessWidget {
  final String imagePath; // asset path
  const BannerImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          imagePath,
          fit: BoxFit.fitWidth,
          width: double.infinity,
          height: 200, // optional height
        ),
      ),
    );
  }
}
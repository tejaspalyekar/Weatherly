import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingscreenTodaysdata extends StatelessWidget {
  const LoadingscreenTodaysdata({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: const Color.fromARGB(121, 207, 207, 207),
      baseColor: const Color.fromARGB(117, 139, 139, 139),
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 150,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 104, 104, 104)),
      ),
    );
  }
}

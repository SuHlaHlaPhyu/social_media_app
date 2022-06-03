import 'package:flutter/material.dart';

import '../resources/dimens.dart';
class ProfileImageView extends StatelessWidget {
  String image;
  ProfileImageView({required this.image});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(
        image,
      ),
      radius: MARGIN_LARGE,
    );
  }
}
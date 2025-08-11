/*
#   Copyright 2022 (C) Blink Tech LLC - All Rights Reserved
#
#   This source code is protected under international copyright law.  All rights
#   reserved and protected by the copyright holders.
#   All files are confidential and only available to authorized individuals with the
#   permission of the copyright holders. If you encounter any file and do not have
#   permission, please get in touch with the copyright holders and delete this file.
*/
import 'package:blink_component/blink_component.dart';
import 'package:flutter/material.dart';

import '../../config/assets.dart';

class NoPlacesFoundWidget extends StatelessWidget {
  final MyColorsPalette palette;

  const NoPlacesFoundWidget({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: NoResultsFoundWidget(
          searchNotFoundImage: AppImages.errorSearchImage,
          backgroundImage: AppImages.errorBackgroundImage,
      ),
    );
  }
}

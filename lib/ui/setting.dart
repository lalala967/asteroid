import 'package:flutter/material.dart';

import 'package:tech_pirates/core/utils/text.dart';
import 'package:tech_pirates/core/widgets/lang_container.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleText(title: "Setting"),
      ),
      body: const Column(
        children: [
          LangContainer(),
        ],
      ),
    );
  }
}

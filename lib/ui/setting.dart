import 'package:flutter/material.dart';

import 'package:tech_pirates/core/utils/text.dart';
import 'package:tech_pirates/core/widgets/lang_container.dart';
import 'package:tech_pirates/core/widgets/setting_container.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  void changePage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleText(title: "Setting"),
      ),
      body: Column(
        children: [
          const LangContainer(),
          SettingContainer(
            whatHeSelected: "Profile",
            title: "Profile",
            caption: "NAME",
            fun: changePage,
          ),
        ],
      ),
    );
  }
}

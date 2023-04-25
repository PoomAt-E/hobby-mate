import 'package:flutter/material.dart';

import '../style/style.dart';

class MainAppbar extends StatelessWidget with PreferredSizeWidget {
  const MainAppbar({super.key, this.hasBackBtn = false});

  final bool hasBackBtn;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        '취미에 취하다',
        style: TextStyles.appbarTextStyle,
      ),
      leading: hasBackBtn
          ? IconButton(
              icon:
                  const Icon(Icons.arrow_back_ios_sharp, color: Colors.black54),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
    );
  }
}

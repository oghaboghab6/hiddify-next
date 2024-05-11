import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hiddify/core/localization/translations.dart';
import 'package:hiddify/core/router/router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hiddify/utils/globals.dart' as globals;

// GlobalKey<HomePage> globalKey = GlobalKey();import 'home_page.dart';


class EmptyProfilesHomeBody extends HookConsumerWidget {
  const EmptyProfilesHomeBody({super.key,     required this.onTap,
  });
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  (globals.globalToken == "")? [
          Text(t.home.emptyProfilesMsg),
          const Gap(16),
          OutlinedButton.icon(
           // onPressed: () => const AddProfileRoute().push(context),
           // onPressed: () =>{const LoginRoute().push(context)} ,
            onPressed: onTap ,
            icon: const Icon(FluentIcons.person_board_20_regular),
            label: Text(t.profile.add.buttonText),
            // style: OutlinedButton.styleFrom(
            //   side: BorderSide(width: 1.0, color: Color(0xffea5555)),
            // ),
          ),
        ]
        :
            []
        ,

      ),
    );
  }
}

class EmptyActiveProfileHomeBody extends HookConsumerWidget {
  const EmptyActiveProfileHomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(t.home.noActiveProfileMsg),
          const Gap(16),
          OutlinedButton(
            onPressed: () => const ProfilesOverviewRoute().push(context),
            child: Text(t.profile.overviewPageTitle),
          ),
        ],
      ),
    );
  }
}

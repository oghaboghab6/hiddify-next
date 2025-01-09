import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiddify/core/router/app_router.dart';
import 'package:hiddify/features/common/adaptive_root_scaffold.dart';
import 'package:hiddify/features/config_device/widget/config_device_page2.dart';
import 'package:hiddify/features/config_option/overview/config_options_page.dart';
import 'package:hiddify/features/config_option/widget/quick_settings_modal.dart';

import 'package:hiddify/features/home/widget/home_page.dart';
import 'package:hiddify/features/intro/widget/intro_page.dart';
import 'package:hiddify/features/log/overview/logs_overview_page.dart';
import 'package:hiddify/features/login/widget/login_page.dart';
import 'package:hiddify/features/config_device/widget/config_device_page.dart';
import 'package:hiddify/features/per_app_proxy/overview/per_app_proxy_page.dart';
import 'package:hiddify/features/profile/add/add_profile_modal.dart';
import 'package:hiddify/features/profile/details/profile_details_page.dart';
import 'package:hiddify/features/profile/overview/profiles_overview_page.dart';
import 'package:hiddify/features/proxy/overview/proxies_overview_page.dart';
import 'package:hiddify/features/settings/about/about_page.dart';
import 'package:hiddify/features/settings/overview/settings_overview_page.dart';
import 'package:hiddify/features/webview/widget/webview_page.dart';
import 'package:hiddify/utils/utils.dart';

import '../../features/config_device/widget/config_location_page.dart';
import '../../features/config_device/widget/config_no_account_page.dart';
import '../../features/login/widget/login_config_page.dart';
import '../../features/login/widget/login_email_page.dart';
import '../../features/login/widget/select_way_login_page.dart';
import '../../features/webview/widget/webview_page_about.dart';

part 'routes.g.dart';

GlobalKey<NavigatorState>? _dynamicRootKey = useMobileRouter ? rootNavigatorKey : null;

@TypedShellRoute<MobileWrapperRoute>(
  routes: [
    TypedGoRoute<HomeRoute>(
      path: "/",
      name: HomeRoute.name,
      routes: [
        TypedGoRoute<AddProfileRoute>(
          path: "add",
          name: AddProfileRoute.name,
        ),
        TypedGoRoute<ProfilesOverviewRoute>(
          path: "profiles",
          name: ProfilesOverviewRoute.name,
        ),
        TypedGoRoute<NewProfileRoute>(
          path: "profiles/new",
          name: NewProfileRoute.name,
        ),
        TypedGoRoute<ProfileDetailsRoute>(
          path: "profiles/:id",
          name: ProfileDetailsRoute.name,
        ),
        TypedGoRoute<ConfigOptionsRoute>(
          path: "config-options",
          name: ConfigOptionsRoute.name,
        ),
        TypedGoRoute<QuickSettingsRoute>(
          path: "quick-settings",
          name: QuickSettingsRoute.name,
        ),
        TypedGoRoute<SettingsRoute>(
          path: "settings",
          name: SettingsRoute.name,
          routes: [
            TypedGoRoute<PerAppProxyRoute>(
              path: "per-app-proxy",
              name: PerAppProxyRoute.name,
            ),
          ],
        ),
        TypedGoRoute<LogsOverviewRoute>(
          path: "logs",
          name: LogsOverviewRoute.name,
        ),
        TypedGoRoute<AboutRoute>(
          path: "about",
          name: AboutRoute.name,
        ),
        TypedGoRoute<LoginRoute>(
          path: "login",
          name: LoginRoute.name,
        ),
        TypedGoRoute<SelectWayLoginRoute>(
          path: "SelectWayLogin",
          name: SelectWayLoginRoute.name,
        ),
        TypedGoRoute<LoginConfigRoute>(
          path: "LoginConfig",
          name: LoginConfigRoute.name,
        ),
        TypedGoRoute<LoginEmailRoute>(
          path: "LoginEmail",
          name: LoginEmailRoute.name,
        ),
        TypedGoRoute<ConfigDeviceRoute>(
          path: "ConfigDevice",
          name: ConfigDeviceRoute.name,
        ),
        TypedGoRoute<ConfigDeviceRoute2>(
          path: "ConfigDevice2",
          name: ConfigDeviceRoute2.name,
        ),
        TypedGoRoute<ConfigLocationRoute>(
          path: "ConfigLocation",
          name: ConfigLocationRoute.name,
        ),
        TypedGoRoute<ConfigNoAccountRoute>(
          path: "ConfigNoAccount",
          name: ConfigNoAccountRoute.name,
        ),
        TypedGoRoute<WebViewRoute>(
          path: "webview",
          name: WebViewRoute.name,
        ),
        TypedGoRoute<WebViewAboutRoute>(
          path: "webview_about",
          name: WebViewAboutRoute.name,
        ),
      ],
    ),
    TypedGoRoute<ProxiesRoute>(
      path: "/proxies",
      name: ProxiesRoute.name,
    ),
  ],
)
class MobileWrapperRoute extends ShellRouteData {
  const MobileWrapperRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return AdaptiveRootScaffold(navigator);
  }
}

@TypedShellRoute<DesktopWrapperRoute>(
  routes: [
    TypedGoRoute<HomeRoute>(
      path: "/",
      name: HomeRoute.name,
      routes: [
        TypedGoRoute<AddProfileRoute>(
          path: "add",
          name: AddProfileRoute.name,
        ),
        TypedGoRoute<ProfilesOverviewRoute>(
          path: "profiles",
          name: ProfilesOverviewRoute.name,
        ),
        TypedGoRoute<NewProfileRoute>(
          path: "profiles/new",
          name: NewProfileRoute.name,
        ),
        TypedGoRoute<ProfileDetailsRoute>(
          path: "profiles/:id",
          name: ProfileDetailsRoute.name,
        ),
        TypedGoRoute<QuickSettingsRoute>(
          path: "quick-settings",
          name: QuickSettingsRoute.name,
        ),
        TypedGoRoute<ConfigOptionsRoute>(
          path: "config-options",
          name: ConfigOptionsRoute.name,
        ),
        // TypedGoRoute<SettingsRoute>(
        //   path: "/settings",
        //   name: SettingsRoute.name,
        //   routes: [
        //     TypedGoRoute<GeoAssetsRoute>(
        //       path: "routing-assets",
        //       name: GeoAssetsRoute.name,
        //     ),
        //   ],
        // ),
        TypedGoRoute<SettingsRoute>(
          path: "settings",
          name: SettingsRoute.name,
          routes: [
            TypedGoRoute<PerAppProxyRoute>(
              path: "per-app-proxy",
              name: PerAppProxyRoute.name,
            ),
          ],
        ),
        TypedGoRoute<LogsOverviewRoute>(
          path: "/logs",
          name: LogsOverviewRoute.name,
        ),
        TypedGoRoute<AboutRoute>(
          path: "/about",
          name: AboutRoute.name,
        ),
        TypedGoRoute<LoginRoute>(
          path: "/login",
          name: LoginRoute.name,
        ),
        TypedGoRoute<SelectWayLoginRoute>(
          path: "/SelectWayLogin",
          name: SelectWayLoginRoute.name,
        ),
        TypedGoRoute<LoginConfigRoute>(
          path: "/LoginConfig",
          name: LoginConfigRoute.name,
        ),
        TypedGoRoute<LoginEmailRoute>(
          path: "/LoginEmail",
          name: LoginEmailRoute.name,
        ),
        TypedGoRoute<ConfigDeviceRoute>(
          path: "/ConfigDevice",
          name: ConfigDeviceRoute.name,
        ),
        TypedGoRoute<ConfigDeviceRoute2>(
          path: "/ConfigDevice2",
          name: ConfigDeviceRoute2.name,
        ),
        TypedGoRoute<ConfigLocationRoute>(
          path: "/ConfigLocation",
          name: ConfigLocationRoute.name,
        ),
        TypedGoRoute<ConfigNoAccountRoute>(
          path: "/ConfigNoAccount",
          name: ConfigNoAccountRoute.name,
        ),
        TypedGoRoute<WebViewRoute>(
          path: "/webview",
          name: WebViewRoute.name,
        ),
        TypedGoRoute<WebViewAboutRoute>(
          path: "/webview_about",
          name: WebViewAboutRoute.name,
        ),
      ],
    ),
    TypedGoRoute<ProxiesRoute>(
      path: "/proxies",
      name: ProxiesRoute.name,
    ),

  ],
)
class DesktopWrapperRoute extends ShellRouteData {
  const DesktopWrapperRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return AdaptiveRootScaffold(navigator);
  }
}

@TypedGoRoute<IntroRoute>(path: "/intro", name: IntroRoute.name)
class IntroRoute extends GoRouteData {
  const IntroRoute();
  static const name = "Intro";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(
      fullscreenDialog: true,
      name: name,
      child: IntroPage(),
    );
  }
}

class HomeRoute extends GoRouteData {
  const HomeRoute();
  static const name = "Home";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(
      name: name,
      child: HomePage(),
    );
  }
}

class ProxiesRoute extends GoRouteData {
  const ProxiesRoute();
  static const name = "Proxies";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(
      name: name,
      child: ProxiesOverviewPage(),
    );
  }
}

class AddProfileRoute extends GoRouteData {
  const AddProfileRoute({this.url});

  final String? url;

  static const name = "Add Profile";

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return BottomSheetPage(
      fixed: true,
      name: name,
      builder: (controller) => AddProfileModal(
        url: url,
        scrollController: controller,
      ),
    );
  }
}

class ProfilesOverviewRoute extends GoRouteData {
  const ProfilesOverviewRoute();
  static const name = "Profiles";

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return BottomSheetPage(
      name: name,
      builder: (controller) => ProfilesOverviewModal(scrollController: controller),
    );
  }
}

class NewProfileRoute extends GoRouteData {
  const NewProfileRoute();
  static const name = "New Profile";

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const MaterialPage(
      fullscreenDialog: true,
      name: name,
      child: ProfileDetailsPage("new"),
    );
  }
}

class ProfileDetailsRoute extends GoRouteData {
  const ProfileDetailsRoute(this.id);
  final String id;
  static const name = "Profile Details";

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(
      fullscreenDialog: true,
      name: name,
      child: ProfileDetailsPage(id),
    );
  }
}

class LogsOverviewRoute extends GoRouteData {
  const LogsOverviewRoute();
  static const name = "Logs";

  static final GlobalKey<NavigatorState>? $parentNavigatorKey = _dynamicRootKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (useMobileRouter) {
      return const MaterialPage(
        name: name,
        child: LogsOverviewPage(),
      );
    }
    return const NoTransitionPage(name: name, child: LogsOverviewPage());
  }
}

class QuickSettingsRoute extends GoRouteData {
  const QuickSettingsRoute();
  static const name = "Quick Settings";

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return BottomSheetPage(
      fixed: true,
      name: name,
      builder: (controller) => const QuickSettingsModal(),
    );
  }
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();
  static const name = "Settings";

  static final GlobalKey<NavigatorState>? $parentNavigatorKey = _dynamicRootKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (useMobileRouter) {
      return const MaterialPage(
        name: name,
        child: SettingsOverviewPage(),
      );
    }
    return const NoTransitionPage(name: name, child: SettingsOverviewPage());
  }
}

class ConfigOptionsRoute extends GoRouteData {
  const ConfigOptionsRoute({this.section});
  final String? section;
  static const name = "Config Options";

  static final GlobalKey<NavigatorState>? $parentNavigatorKey = _dynamicRootKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (useMobileRouter) {
      return MaterialPage(
        name: name,
        child: ConfigOptionsPage(section: section),
      );
    }
    return NoTransitionPage(
      name: name,
      child: ConfigOptionsPage(section: section),
    );
  }
}

class PerAppProxyRoute extends GoRouteData {
  const PerAppProxyRoute();
  static const name = "Per-app Proxy";

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const MaterialPage(
      fullscreenDialog: true,
      name: name,
      child: PerAppProxyPage(),
    );
  }
}

class AboutRoute extends GoRouteData {
  const AboutRoute();
  static const name = "About";

  static final GlobalKey<NavigatorState>? $parentNavigatorKey = _dynamicRootKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (useMobileRouter) {
      return const MaterialPage(
        name: name,
        child: AboutPage(),
      );
    }
    return const NoTransitionPage(name: name, child: AboutPage());
  }
}
class LoginRoute extends GoRouteData {
  const LoginRoute();
  static const name = "Login";

  // static final GlobalKey<NavigatorState>? $parentNavigatorKey = _dynamicRootKey;
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (useMobileRouter) {
      return const MaterialPage(
        name: name,
        child: LoginPage(),
      );
    }
    return const NoTransitionPage(name: name, child: LoginPage());
  }
}
class SelectWayLoginRoute extends GoRouteData {
  const SelectWayLoginRoute();
  static const name = "SelectWayLogin";

  // static final GlobalKey<NavigatorState>? $parentNavigatorKey = _dynamicRootKey;
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (useMobileRouter) {
      return const MaterialPage(
        name: name,
        child: SelectWayLoginPage(),
      );
    }
    return const NoTransitionPage(name: name, child: SelectWayLoginPage());
  }
}
class LoginConfigRoute extends GoRouteData {
  const LoginConfigRoute();
  static const name = "LoginConfig";

  // static final GlobalKey<NavigatorState>? $parentNavigatorKey = _dynamicRootKey;
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (useMobileRouter) {
      return const MaterialPage(
        name: name,
        child: LoginConfigPage(),
      );
    }
    return const NoTransitionPage(name: name, child: LoginConfigPage());
  }
}
class LoginEmailRoute extends GoRouteData {
  const LoginEmailRoute();
  static const name = "LoginEmail";

  // static final GlobalKey<NavigatorState>? $parentNavigatorKey = _dynamicRootKey;
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (useMobileRouter) {
      return const MaterialPage(
        name: name,
        child: LoginEmailPage(),
      );
    }
    return const NoTransitionPage(name: name, child: LoginEmailPage());
  }
}
class ConfigLocationRoute extends GoRouteData {
  const ConfigLocationRoute();
  static const name = "ConfigLocation";

  // static final GlobalKey<NavigatorState>? $parentNavigatorKey = _dynamicRootKey;
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (useMobileRouter) {
      return const MaterialPage(
        name: name,
        child: ConfigLocationPage(),
      );
    }
    return const NoTransitionPage(name: name, child: ConfigLocationPage());
  }
}
class ConfigNoAccountRoute extends GoRouteData {
  const ConfigNoAccountRoute();
  static const name = "ConfigNoAccount";

  // static final GlobalKey<NavigatorState>? $parentNavigatorKey = _dynamicRootKey;
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (useMobileRouter) {
      return const MaterialPage(
        name: name,
        child: ConfigNoAccountPage(),
      );
    }
    return const NoTransitionPage(name: name, child: ConfigNoAccountPage());
  }
}
class ConfigDeviceRoute extends GoRouteData {
  const ConfigDeviceRoute();
  static const name = "ConfigDevice";

  // static final GlobalKey<NavigatorState>? $parentNavigatorKey = _dynamicRootKey;
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (useMobileRouter) {
      return const MaterialPage(
        name: name,
        child: ConfigDevicePage(),
      );
    }
    return const NoTransitionPage(name: name, child: ConfigDevicePage());
  }
}
class ConfigDeviceRoute2 extends GoRouteData {
  const ConfigDeviceRoute2();
  static const name = "ConfigDevice2";

  // static final GlobalKey<NavigatorState>? $parentNavigatorKey = _dynamicRootKey;
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (useMobileRouter) {
      return const MaterialPage(
        name: name,
        child: ConfigDevicePage2(),
      );
    }
    return const NoTransitionPage(name: name, child: ConfigDevicePage2());
  }
}
class WebViewRoute extends GoRouteData {
  const WebViewRoute();
  static const name = "WebView";

  // static final GlobalKey<NavigatorState>? $parentNavigatorKey = _dynamicRootKey;
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (useMobileRouter) {
      return const MaterialPage(
        name: name,
        child: WebViewPage(),
      );
    }
    return const NoTransitionPage(name: name, child: WebViewPage());
  }
}
class WebViewAboutRoute extends GoRouteData {
  const WebViewAboutRoute();
  static const name = "WebViewAbout";

  // static final GlobalKey<NavigatorState>? $parentNavigatorKey = _dynamicRootKey;
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (useMobileRouter) {
      return const MaterialPage(
        name: name,
        child: WebViewAboutPage(),
      );
    }
    return const NoTransitionPage(name: name, child: WebViewAboutPage());
  }
}
import 'dart:async';

import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/main.dart';

export 'package:go_router/go_router.dart';

export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => appStateNotifier.showSplashImage
          ? Builder(
              builder: (context) => Container(
                color: Colors.transparent,
                child: Image.asset(
                  'assets/images/intro.gif',
                  fit: BoxFit.cover,
                ),
              ),
            )
          : LoginPageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => Container(
                    color: Colors.white,
                    child: Image.asset(
                      'assets/images/intro.gif',

                    ),
                  ),
                )
              : LoginPageWidget(),
        ),
        FFRoute(
          name: 'loginPage',
          path: '/loginPage',
          builder: (context, params) => LoginPageWidget(),
        ),
        FFRoute(
          name: 'registerAccount',
          path: '/registerAccount',
          builder: (context, params) => RegisterAccountWidget(),
        ),
        FFRoute(
          name: 'completeProfile',
          path: '/completeProfile',
          builder: (context, params) => CompleteProfileWidget(),
        ),
        FFRoute(
          name: 'forgotPassword',
          path: '/forgotPassword',
          builder: (context, params) => ForgotPasswordWidget(),
        ),
        FFRoute(
          name: 'onboarding',
          path: '/onboarding',
          builder: (context, params) => OnboardingWidget(),
        ),
        FFRoute(
          name: 'createBudgetBegin',
          path: '/createBudgetBegin',
          builder: (context, params) => CreateBudgetBeginWidget(),
        ),
        FFRoute(
          name: 'MY_Card',
          path: '/mYCard',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'MY_Card')
              : MYCardWidget(),
        ),
        FFRoute(
          name: 'MY_Budgets',
          path: '/mYBudgets',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'MY_Budgets')
              : MYBudgetsWidget(),
        ),
        FFRoute(
          name: 'paymentDetails',
          path: '/paymentDetails',
          builder: (context, params) => PaymentDetailsWidget(),
        ),
        FFRoute(
          name: 'MY_profilePage',
          path: '/mYProfilePage',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'MY_profilePage')
              : MYProfilePageWidget(),
        ),
        FFRoute(
          name: 'budgetDetails',
          path: '/budgetDetails',
          builder: (context, params) => BudgetDetailsWidget(),
        ),
        FFRoute(
          name: 'transferComplete',
          path: '/transferComplete',
          builder: (context, params) => TransferCompleteWidget(),
        ),
        FFRoute(
          name: 'transferFunds',
          path: '/transferFunds',
          builder: (context, params) => TransferFundsWidget(),
        ),
        FFRoute(
          name: 'requestFunds',
          path: '/requestFunds',
          builder: (context, params) => RequestFundsWidget(),
        ),
        FFRoute(
          name: 'createBudget',
          path: '/createBudget',
          builder: (context, params) => CreateBudgetWidget(),
        ),
        FFRoute(
          name: 'transaction_ADD',
          path: '/transactionADD',
          builder: (context, params) => TransactionADDWidget(),
        ),
        FFRoute(
          name: 'transaction_EDIT',
          path: '/transactionEDIT',
          builder: (context, params) => TransactionEDITWidget(),
        ),
        FFRoute(
          name: 'editProfile',
          path: '/editProfile',
          builder: (context, params) => EditProfileWidget(),
        ),
        FFRoute(
          name: 'changePassword',
          path: '/changePassword',
          builder: (context, params) => ChangePasswordWidget(),
        ),
        FFRoute(
          name: 'notificationsSettings',
          path: '/notificationsSettings',
          builder: (context, params) => NotificationsSettingsWidget(),
        ),
        FFRoute(
          name: 'tutorial_PROFILE',
          path: '/tutorialPROFILE',
          builder: (context, params) => TutorialPROFILEWidget(),
        ),
        FFRoute(
          name: 'homePage',
          path: '/homePage',
          builder: (context, params) => HomePageWidget(),
        ),
        FFRoute(
          name: 'budget_DELETE',
          path: '/budgetDELETE',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'budget_DELETE')
              : BudgetDELETEWidget(),
        ),
        FFRoute(
          name: 'profilepage',
          path: '/profilepage',
          builder: (context, params) => ProfilepageWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).transitionsBuilder,
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

import 'package:go_router/go_router.dart';
import 'package:harris_j_system/layout/bom_scaffold.dart';
import 'package:harris_j_system/layout/consultancy_scaffold.dart';
import 'package:harris_j_system/screens/auth/basic_info_screen.dart';
import 'package:harris_j_system/screens/bom/bom_add_address_screen.dart';
import 'package:harris_j_system/screens/bom/bom_add_consultancy_screen.dart';
import 'package:harris_j_system/screens/bom/bom_consultancy_screen.dart';
import 'package:harris_j_system/screens/bom/bom_dashboard_screen.dart';
import 'package:harris_j_system/screens/bom/bom_finance_screen.dart';
import 'package:harris_j_system/screens/bom/bom_report_screen.dart';
import 'package:harris_j_system/screens/bom/bom_static_setting_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_dashboard_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_feedback_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_static_settings_screen.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/screens/shared/login_screen.dart';
import 'package:harris_j_system/screens/shared/on_board_screen.dart';
import 'package:harris_j_system/screens/shared/splash_screen.dart';
import 'package:harris_j_system/layout/operator_scaffold.dart';
import 'package:harris_j_system/screens/operator/operator_dashboard_screen.dart';


final GoRouter goRouter = GoRouter(
  initialLocation: Constant.splash,
  routes: [
    /// SHARED
    GoRoute(
        path: Constant.splash,
        builder: (context, state) => const SplashScreen()),
    GoRoute(
        path: Constant.onBoard,
        builder: (context, state) => const OnBoardScreen()),
    GoRoute(
        path: Constant.login, builder: (context, state) => const LoginScreen()),

    /// BOM FLOW
    ShellRoute(
      builder: (context, state, child) => BomScaffold(child: child),
      routes: [
        GoRoute(
          path: Constant.bomDashBoardScreen,
          builder: (context, state) => const BomDashboardScreen(),
        ),
        GoRoute(
          path: Constant.bomConsultancyScreen,
          builder: (context, state) => const BomConsultancyScreen(),
        ),
        GoRoute(
          path: Constant.bomAddConsultancyScreen,
          builder: (context, state) {
            final consultancy =
                state.extra as Map<String, dynamic>?; // or a model
            return BomAddConsultancyScreen(consultancy: consultancy);
          },
        ),
        GoRoute(
          path: Constant.bomAddAddressScreen,
          builder: (context, state) => const BomAddAddressBottomSheet(),
        ),
        GoRoute(
          path: Constant.bomFinanceScreen,
          builder: (context, state) => const BomFinanceScreen(),
        ),
        GoRoute(
          path: Constant.bomReportScreen,
          builder: (context, state) => const BomReportScreen(),
        ),
        GoRoute(
          path: Constant.bomStaticScreenScreen,
          builder: (context, state) => const BomStaticSettingsScreen(),
        ),

          GoRoute(
          path: Constant.consultancyFeedbackScreen,
          builder: (context, state) => const consultancyFeedbackScreen(),
          ),

      ],
    ),

    /// CONSULTANCY FLOW
    ShellRoute(
      builder: (context, state, child) => ConsultancyScaffold(child: child),
      routes: [
        GoRoute(
          path: Constant.consultancyDashBoardScreen,
          builder: (context, state) => const ConsultancyDashboardScreen(),
        ),
        GoRoute(
          path: Constant.consultancySettingsScreen,
          builder: (context, state) => const ConsultancySettingsScreen(),
        ),
      ],
    ),

    ShellRoute(
      builder: (context, state, child) => OperatorScaffold(child: child),
      routes: [
        GoRoute(
          path: Constant.operatorDashboardScreen,
          builder: (context, state) => const OperatorDashboardScreen(),
        ),
      ],
    )
  ],
);

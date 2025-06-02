import 'package:go_router/go_router.dart';
import 'package:harris_j_system/layout/bom_scaffold.dart';
import 'package:harris_j_system/layout/consultancy_scaffold.dart';
<<<<<<< Updated upstream
=======
import 'package:harris_j_system/layout/consultant_scaffold.dart';
import 'package:harris_j_system/layout/operator_scaffold.dart';
>>>>>>> Stashed changes
import 'package:harris_j_system/screens/auth/basic_info_screen.dart';
import 'package:harris_j_system/screens/bom/bom_add_address_screen.dart';
import 'package:harris_j_system/screens/bom/bom_add_consultancy_screen.dart';
import 'package:harris_j_system/screens/bom/bom_consultancy_screen.dart';
import 'package:harris_j_system/screens/bom/bom_dashboard_screen.dart';
import 'package:harris_j_system/screens/bom/bom_finance_screen.dart';
import 'package:harris_j_system/screens/bom/bom_report_screen.dart';
<<<<<<< Updated upstream
import 'package:harris_j_system/screens/consultancy/claim_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultant_dashboard.dart';
import 'package:harris_j_system/screens/consultancy/timesheet_screen.dart';
=======
import 'package:harris_j_system/screens/bom/bom_static_setting_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_add_user_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_client_list_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_dashboard_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_feedback_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_report_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_static_settings_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_user_list_screen.dart';
import 'package:harris_j_system/screens/consultant/consultant_claim_screen.dart';
import 'package:harris_j_system/screens/consultant/consultant_dashboard_screen.dart';
import 'package:harris_j_system/screens/consultant/consultant_timesheet_screen.dart';
>>>>>>> Stashed changes
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/screens/operator/operator_dashboard_screen.dart';
import 'package:harris_j_system/screens/shared/login_screen.dart';
import 'package:harris_j_system/screens/shared/on_board_screen.dart';
import 'package:harris_j_system/screens/shared/splash_screen.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: Constant.splash,
  routes: [

    /// SHARED
    GoRoute(path: Constant.splash, builder: (context, state) => const SplashScreen()),
    GoRoute(path: Constant.onBoard, builder: (context, state) => const OnBoardScreen()),
    GoRoute(path: Constant.login, builder: (context, state) => const LoginScreen()),



    /// CONSULTANCY FLOW
    ShellRoute(
      builder: (context, state, child) => ConsultancyScaffold(child: child),
      routes: [
        GoRoute(
          path: Constant.basicInfo,
          builder: (context, state) => const BasicInformationScreen(),
        ),
        GoRoute(
          path: Constant.consultancyDashBoardScreen,
          builder: (context, state) => const ConsultancyDashboardScreen(),
        ),
        GoRoute(
          path: Constant.timeSheet,
          builder: (context, state) => const TimeSheetScreen(),
        ),
        GoRoute(
          path: Constant.claimScreen,
          builder: (context, state) => const ClaimScreen(),
        ),
      ],
    ),

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
            final consultancy = state.extra as Map<String, dynamic>?; // or a model
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
        ),  GoRoute(
          path: Constant.bomReportScreen,
          builder: (context, state) => const BomReportScreen(),
        ),
<<<<<<< Updated upstream
      ],
    ),

=======
        GoRoute(
          path: Constant.bomStaticScreenScreen,
          builder: (context, state) => const BomStaticSettingsScreen(),
        ),
        GoRoute(
          path: Constant.consultancyReportScreen,
          builder: (context, state) => const ConsultancyReportScreen(),
        ),
        GoRoute(
          path: Constant.consultancyClientListScreen,
          builder: (context, state) => const ConsultancyClientListScreen(),
        ),GoRoute(
          path: Constant.consultancyUserListScreen,
          builder: (context, state) => const ConsultancyUserListScreen(),
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
          path: Constant.consultancyAddUserScreen,
          builder: (context, state) => const ConsultancyAddUserScreen(),
        ),
        GoRoute(
          path: Constant.consultancySettingsScreen,
          builder: (context, state) => const ConsultancySettingsScreen(),
        ),
      ],
    ),

    /// Operator Flow
    ShellRoute(
      builder: (context, state, child) => OperatorScaffold(child: child),
      routes: [
        GoRoute(
          path: Constant.operatorDashboardScreen,
          builder: (context, state) => const OperatorDashboardScreen(),
        ),
      ],
    )
>>>>>>> Stashed changes
  ],
);

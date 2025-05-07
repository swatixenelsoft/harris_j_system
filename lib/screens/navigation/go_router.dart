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
import 'package:harris_j_system/screens/consultancy/claim_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultant_dashboard.dart';
import 'package:harris_j_system/screens/consultancy/timesheet_screen.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
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
      ],
    ),

  ],
);

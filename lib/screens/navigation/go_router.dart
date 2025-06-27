import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harris_j_system/layout/bom_scaffold.dart';
import 'package:harris_j_system/layout/consultancy_scaffold.dart';
import 'package:harris_j_system/layout/consultant_scaffold.dart';
import 'package:harris_j_system/layout/finance_scaffold.dart';
import 'package:harris_j_system/layout/hr_scaffold.dart';
import 'package:harris_j_system/layout/operator_scaffold.dart';
import 'package:harris_j_system/screens/auth/basic_info_screen.dart';
import 'package:harris_j_system/screens/bom/bom_add_address_screen.dart';
import 'package:harris_j_system/screens/bom/bom_add_consultancy_screen.dart';
import 'package:harris_j_system/screens/bom/bom_consultancy_screen.dart';
import 'package:harris_j_system/screens/bom/bom_dashboard_screen.dart';
import 'package:harris_j_system/screens/bom/bom_finance_screen.dart';
import 'package:harris_j_system/screens/bom/bom_report_screen.dart';
import 'package:harris_j_system/screens/bom/bom_static_setting_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_add_user_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_client_list_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_dashboard_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_feedback_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_report_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_static_settings_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_user_list_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_add_client_screen.dart';
import 'package:harris_j_system/screens/consultant/consultant_claim_screen.dart';
import 'package:harris_j_system/screens/consultant/consultant_dashboard_screen.dart';
import 'package:harris_j_system/screens/consultant/consultant_timesheet_screen.dart';
import 'package:harris_j_system/screens/finance/finance_add_group_screen.dart';
import 'package:harris_j_system/screens/finance/finance_claims_invoice_screen.dart';
import 'package:harris_j_system/screens/finance/finance_claims_screen.dart';
import 'package:harris_j_system/screens/finance/finance_dashboard_screen.dart';
import 'package:harris_j_system/screens/finance/finance_feedback_screen.dart';
import 'package:harris_j_system/screens/finance/finance_invoice_screen.dart';
import 'package:harris_j_system/screens/finance/finance_reports_screen.dart';
import 'package:harris_j_system/screens/finance/finance_screen.dart';
import 'package:harris_j_system/screens/finance/finance_static_settings_screen.dart';
import 'package:harris_j_system/screens/hr/hr_add_consultant_screen.dart';

import 'package:harris_j_system/screens/hr/hr_consultant_claim_screen.dart';
import 'package:harris_j_system/screens/hr/hr_consultant_list_screen.dart';
import 'package:harris_j_system/screens/hr/hr_consultant_timesheet_screen.dart';
import 'package:harris_j_system/screens/hr/hr_dashboard_screen.dart';
import 'package:harris_j_system/screens/hr/hr_feedback_screen.dart';
import 'package:harris_j_system/screens/hr/hr_report_screen.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/screens/operator/operator_claims_screen.dart';
import 'package:harris_j_system/screens/operator/operator_dashboard_screen.dart';
import 'package:harris_j_system/screens/operator/operator_feedback_screen.dart';

import 'package:harris_j_system/screens/operator/operator_human_resources_screen.dart';
import 'package:harris_j_system/screens/operator/operator_reports_screen.dart';

import 'package:harris_j_system/screens/shared/login_screen.dart';
import 'package:harris_j_system/screens/shared/on_board_screen.dart';
import 'package:harris_j_system/screens/shared/splash_screen.dart';

// Define navigator keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _consultantShellKey = GlobalKey<NavigatorState>();
final _bomShellKey = GlobalKey<NavigatorState>();
final _consultancyShellKey = GlobalKey<NavigatorState>();
final _hrShellKey = GlobalKey<NavigatorState>();
final _operatorShellKey = GlobalKey<NavigatorState>();
final _financeShellKey = GlobalKey<NavigatorState>();

final GoRouter goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey, // Root navigator key
  initialLocation: Constant.splash,
  routes: [
    /// SHARED
    GoRoute(
      path: Constant.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: Constant.onBoard,
      builder: (context, state) => const OnBoardScreen(),
    ),
    GoRoute(
      path: Constant.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Constant.addAddressScreen,
      builder: (context, state) => const AddAddressBottomSheet(),
    ),

    /// CONSULTANT FLOW
    ShellRoute(
      navigatorKey: _consultantShellKey, // Unique key for this ShellRoute
      builder: (context, state, child) => ConsultantScaffold(child: child),
      routes: [
        GoRoute(
          path: Constant.basicInfo,
          builder: (context, state) => const BasicInformationScreen(),
        ),
        GoRoute(
          path: Constant.consultantDashBoardScreen,
          builder: (context, state) => const ConsultantDashboardScreen(),
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
      navigatorKey: _bomShellKey,
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
            final consultancy = state.extra as Map<String, dynamic>?;
            return BomAddConsultancyScreen(consultancy: consultancy);
          },
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
      ],
    ),

    /// CONSULTANCY FLOW
    ShellRoute(
      navigatorKey: _consultancyShellKey,
      builder: (context, state, child) => ConsultancyScaffold(child: child),
      routes: [
        GoRoute(
          path: Constant.consultancyDashBoardScreen,
          builder: (context, state) => const ConsultancyDashboardScreen(),
        ),
        GoRoute(
          path: Constant.consultancyAddUserScreen,
          builder: (context, state) {
            final userList = state.extra as Map<String, dynamic>?;
            return ConsultancyAddUserScreen(userList: userList);
          },
        ),
        GoRoute(
          path: Constant.consultancyAddClientScreen,
          builder: (context, state) {
            final client = state.extra as Map<String, dynamic>?;
            return ConsultancyAddClientScreen(client: client);
          },
        ),
        GoRoute(
          path: Constant.consultancyReportScreen,
          builder: (context, state) => const ConsultancyReportScreen(),
        ),
        GoRoute(
          path: Constant.consultancyClientListScreen,
          builder: (context, state) => const ConsultancyClientListScreen(),
        ),
        GoRoute(
          path: Constant.consultancyUserListScreen,
          builder: (context, state) => const ConsultancyUserListScreen(),
        ),
        GoRoute(
          path: Constant.consultancySettingsScreen,
          builder: (context, state) => const ConsultancySettingsScreen(),
        ),
        GoRoute(
          path: Constant.consultancyFeedbackScreen,
          builder: (context, state) => const consultancyFeedbackScreen(),
        ),
      ],
    ),

    ///OPERATOR FLOW
    ShellRoute(
      navigatorKey: _operatorShellKey,
      builder: (context, state, child) => OperatorScaffold(child: child),
      routes: [
        GoRoute(
          path: Constant.operatorDashboardScreen,
          builder: (context, state) => const OperatorDashboardScreen(),
        ),
        GoRoute(
          path: Constant.humanResourcesScreen,
          builder: (context, state) => const HumanResourcesScreen(),
        ),
        GoRoute(
          path: Constant.operatorClaimScreen,
          builder: (context, state) => const OperatorClaimScreen(),
        ),
        GoRoute(
          path: Constant.operatorReportScreen,
          builder: (context, state) => const OperatorReportScreen(),
        ),
        GoRoute(
          path: Constant.operatorFeedbackScreen,
          builder: (context, state) => const OperatorFeedbackScreen(),
        ),
      ],
    ),

    /// HR FLOW
    ShellRoute(
      navigatorKey: _hrShellKey,
      builder: (context, state, child) => HrScaffold(child: child),
      routes: [
        GoRoute(
          path: Constant.hrDashboardScreen,
          builder: (context, state) => const HrDashboardScreen(),
        ),
        GoRoute(
          path: Constant.hrConsultantListScreen,
          builder: (context, state) => const HrConsultantListScreen(),
        ),
        GoRoute(
          path: Constant.hrAddConsultantScreen,
          builder: (context, state) => const HrAddConsultantScreen(),
        ),
        GoRoute(
          path: Constant.hrReportScreen,
          builder: (context, state) => const HrReportScreen(),
        ),
        GoRoute(
          path: Constant.hrFeedBackScreen,
          builder: (context, state) => const HrFeedBackScreen(),
        ),
        GoRoute(
          path: Constant.hrConsultantTimesheetScreen,
          builder: (context, state) => const HrConsultantTimeSheetScreen(),
        ),
        GoRoute(
          path: Constant.hrConsultantClaimScreen,
          builder: (context, state) => const HrConsultantClaimScreen(),
        ),
      ],
    ),

    ///FINANCE FLOW
    ShellRoute(
      navigatorKey: _financeShellKey,
      builder: (context, state, child) => FinanceScaffold(child: child),
      routes: [
        GoRoute(
          path: Constant.financeDashboardScreen,
          builder: (context, state) => const FinanceDashboardScreen(),
        ),
        GoRoute(
          path: Constant.financeScreen,
          builder: (context, state) => const FinanceScreen(),
        ),
        GoRoute(
          path: Constant.financeClaimScreen,
          builder: (context, state) => const FinanceClaimScreen(),
        ),
        GoRoute(
          path: Constant.financeInvoiceScreen,
          builder: (context, state) => const FinanceInvoiceScreen(),
        ),
        GoRoute(
          path: Constant.financeClaimsInvoiceScreen,
          builder: (context, state) => const FinanceClaimsInvoiceScreen(),
        ),
        GoRoute(
          path: Constant.financeReportScreen,
          builder: (context, state) => const FinanceReportScreen(),
        ),
        GoRoute(
          path: Constant.financeFeedbackScreen,
          builder: (context, state) => const FinanceFeedbackScreen(),
        ),
        GoRoute(
          path: Constant.financeAddGroupScreen,
          builder: (context, state) => const FinanceAddGroupScreen(),
        ),
        GoRoute(
          path: Constant.financeStaticSettingScreen,
          builder: (context, state) => const FinanceStaticSettingScreen(),
        ),

      ],
    ),
  ],
);

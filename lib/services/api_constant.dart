class ApiConstant {
  static const String baseUrl =
      "https://3d-development.com/harris_j_system/api/";
  // static const String baseUrl = "http://192.168.1.9/development/harris_j_system_new/api/";
  static const String imageBaseUrl =
      "https://3d-development.com/harris_j_system/";
  static const String login = "auth/login";
  static const String getConsultancy = "getConsultancy";
  static const String countries = "countries";
  static const String states = "states?country=";
  static const String addConsultancy = "add-consultancy";
  static const String deleteConsultancy = "delete-consultancy";
  static const String updateConsultancy = "update-consultancy";

  //CONSULTANT API URL
  static const String updateBasicInfo = "update-basic";
  static const String getBasic = "consultant/get-basic";
  static const String consultantTimeSheet = "consultant/dashboard/timeline";
  static const String consultantClaimSheet =
      "consultant/dashboard/claimtimeline";
  static const String getLeaveWorkLog = "consultant/get-consultant-details";
  static const String getDashboard = "consultant/get-dashboard";
  static const String feedback = "consultant/feedback/store";
  static const String addTimesheetData = "consultant/add-data";
  static const String addClaimsData = "consultant/add-claim";
  static const String getTimesheetRemarks = "consultant/get-timesheet-remarks";
  static const String getClaimRemarks = "consultant/get-claim-remarks";
  static const String getClaimAndCopies =
      "consultant/get-claim-and-get-copies-tab";
  static const String deleteClaim = "consultant/delete-claim";
  static const String backdatedClaimsData = "consultant/backdated-claims-data";


  static const String addConsultant = "hr/add-consultant";
  static const String clientList = "hr/client-list";
  static const String hrDashBoard = "hr/dashboard-api";
  static const String consultantList = "hr/consultant-list";
  static const String deleteConsultant = "hr/delete-consultant";
  static const String consultantTimesheetListHrTab =
      "hr/consultant-list-hr-tab";
  static const String consultantClaimsListHrTab =
      "hr/consultant-list-claim-tab";

  static const String getClients = "consultancy/getClients";
  static const String addClient = "consultancy/addClient";
  static const String updateClient = "consultancy/updateClient";
  static const String deleteClient = "consultancy/deleteClient";
  static const String getUsers = "consultancy/getUsers";
  static const String addUser = "consultancy/addUser";
  static const String editUser = "consultancy/updateUser";
  static const String deleteUser = "consultancy/deleteUser";
  static const String addLookup = "consultancy-system-property/save";
  static const String addRole = "consultancy-role/save";
  static const String addDesignation = "consultancy-designation/save";
  static const String designationList = "consultancy-designation/listing";
  static const String roleList = "consultancy-role/listing";
  static const String systemPropertyList = "consultancy-system-property/listing";
 static const String createHoliday = "consultancy-holiday/save";
  static const String getHolidayList = "consultancy-holiday/listing";


  static const String operatorDashboard = "operator/client-list";
  static const String operatorClaims = "operator/claimtab-api";
  static const String operatorHumanResource = "operator/hrtab-api";

  static const String financeClientList = "finance/client-list";
  static const String consultantClaimsListFinanceTab =
      "hr/consultant-list-claim-tab";
  static const String consultantTimesheetFinanceTab = "finance/finanetab-api";
  static const String financeAddGroup= "finance/createGroup-api";
  static const String financeClaimInvoiceClientList= "finance/claimInvoiceClientListing-api";
  static const String financeClaimClientConsultants= "finance/claimClientConsultants-api";
  static const String financeGroupList= "finance/InvoiceGroupListing-api";
  static const String financeConsultantList= "finance/getClientConsultants-api";

}

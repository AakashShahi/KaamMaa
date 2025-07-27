class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // For Android Emulator
  // static const String serverAddress = "http://10.0.2.2:5050/api/";

  // For mobile devices
  static const String serverAddress = "http://192.168.1.70:5050/api/";
  static const String imageUrl = "http://192.168.1.70:5050/";

  // static const String imageUrl = "http://10.0.2.2:5050/";

  //Auth
  static const String login = "auth/login";
  static const String register = "auth/register";

  // Customer Category
  static const String customerCategory = "customer/profession";

  // Customer Jobs
  static const String customerPublicJobs = "customer/jobs/open";
  static const String postCustomerJob = "customer/jobs";
  static const String assignWorkerToJob = "customer/jobs/assign";
  static const String deletePostedJob = "customer/jobs/";
  static const String getAssignedJob = "customer/jobs/assigned";
  static const String cancelAssignedJob = "customer/jobs/unassign";
  static const String getRequestedJob = "customer/jobs/requested";
  static const String acceptRequestedJob = "customer/jobs/accept-worker";
  static const String rejectRequestedJob = "customer/jobs/reject-worker";
  static const String getInProgressJob = "customer/jobs/in-progress";
  static const String getCustomer = "customer/me";
  static const String updateCustomer = "customer/me";

  //Customer get workers
  static const String customerGetWorkers = "customer/worker";

  //Customer submit reviews
  static const String postReview = "customer/jobs/review";
  static const String getReview = "customer/review";
  static const String deleteReview = "customer/review";
  static const String deleteAllReview = "customer/review";
}

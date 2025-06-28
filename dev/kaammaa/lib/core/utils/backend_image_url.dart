import 'package:kaammaa/app/constant/api/api_endpoints.dart';

String getBackendImageUrl(String path) {
  // Replace backslashes with forward slashes
  final fixedPath = path.replaceAll('\\', '/');
  print("${ApiEndpoints.imageUrl}$fixedPath");

  return "${ApiEndpoints.imageUrl}$fixedPath";
}

import 'dart:io';

import 'package:dio/dio.dart';

class MyException {

  static ErrorResponse handleDioError(DioException error) {

    if (error.error is SocketException) {
      return ErrorResponse(
        heading: "Network Error",
        message: "No internet connection. Please check your network.",
      );
    }

    switch (error.type) {

      case DioExceptionType.connectionError:
        return ErrorResponse(
          heading: "Connection Failed",
          message: "Unable to connect to the server.",
        );

      case DioExceptionType.connectionTimeout:
        return ErrorResponse(
          heading: "Timeout",
          message: "Connection timeout. Please try again.",
        );

      case DioExceptionType.sendTimeout:
        return ErrorResponse(
          heading: "Request Timeout",
          message: "Request took too long to send.",
        );

      case DioExceptionType.receiveTimeout:
        return ErrorResponse(
          heading: "Server Timeout",
          message: "Server is taking too long to respond.",
        );

      case DioExceptionType.badResponse:

        final statusCode = error.response?.statusCode;

        if (statusCode == 401) {
          return ErrorResponse(
            heading: "Session Expired",
            message: "Your session has expired. Please login again.",
          );
        }

        if (statusCode == 500) {
          return ErrorResponse(
            heading: "Server Error",
            message: "Internal server error. Please try later.",
          );
        }

        return ErrorResponse(
          heading: "Server Error",
          message: "Error Code: ${statusCode ?? "Unknown"}",
        );

      case DioExceptionType.cancel:
        return ErrorResponse(
          heading: "Cancelled",
          message: "Request was cancelled.",
        );

      case DioExceptionType.unknown:
      default:
        return ErrorResponse(
          heading: "Unexpected Error",
          message: "Something went wrong. Please try again.",
        );
    }
  }
}

// /*
//
// class MyException {
//   static String handleDioError(DioException error) {
//     // debugPrint("Error dio MyException 1: $error");
//     // debugPrint("Error dio MyException 2: ${error.error}");
//     // debugPrint("Error dio MyException 3: ${error.type}");
//
//     /// ✅ First handle SocketException (No Internet / DNS issue)
//     if (error.error is SocketException) {
//       return AppStrings.networkError; // "No Internet Connection"
//     }
//
//     switch (error.type) {
//       case DioExceptionType.connectionError:
//         return AppStrings.networkError;
//
//       case DioExceptionType.connectionTimeout:
//         return "Connection timeout. Please try again.";
//
//       case DioExceptionType.sendTimeout:
//         return "Request timeout. Please try again.";
//
//       case DioExceptionType.receiveTimeout:
//         return "Server is taking too long to respond.";
//
//       case DioExceptionType.badResponse:
//         final statusCode = error.response?.statusCode;
//
//         if (statusCode == 401) {
//           return "Session expired. Please login again.";
//         }
//
//         if (statusCode == 500) {
//           return "Internal server error. Please try later.";
//         }
//
//         // return "Server error (${statusCode ?? "Unknown"})";
//         return "Internal Server Issue";
//       */
// /*"Server error: ${error.response?.statusCode} - ${error.response
//             ?.statusMessage}";*//*
//
//
//       case DioExceptionType.cancel:
//         return "Request was cancelled";
//
//       case DioExceptionType.unknown:
//       default:
//         return "Something went wrong. Please try again.";
//     }
//   }
// }
// */

class ErrorResponse {
  final String heading;
  final String message;

  ErrorResponse({
    required this.heading,
    required this.message,
  });
}


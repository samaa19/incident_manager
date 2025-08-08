/*
#   Copyright 2022 (C) Blink Tech LLC - All Rights Reserved
#
#   This source code is protected under international copyright law.  All rights
#   reserved and protected by the copyright holders.
#   All files are confidential and only available to authorized individuals with the
#   permission of the copyright holders. If you encounter any file and do not have
#   permission, please get in touch with the copyright holders and delete this file.
*/
import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout';
        case DioExceptionType.badResponse:
          return 'Server error: ${error.response?.statusCode}';
        case DioExceptionType.cancel:
          return 'Request cancelled';
        case DioExceptionType.connectionError:
          return 'No internet connection';
        default:
          return 'Network error occurred';
      }
    }
    return error.toString();
  }
}

// class DioExceptions implements Exception {
//   final String message;
//
//   DioExceptions.fromDioError(DioException dioError)
//       : message = _getMessage(dioError);
//
//   static String _getMessage(DioException dioError) {
//     switch (dioError.type) {
//       case DioExceptionType.cancel:
//         return "Request to API server was cancelled";
//       case DioExceptionType.connectionTimeout:
//         return "Connection timeout with API server";
//       case DioExceptionType.unknown:
//         return "Connection to API server failed due to internet connection";
//       case DioExceptionType.receiveTimeout:
//         return "Receive timeout in connection with API server";
//       case DioExceptionType.badResponse:
//         return _handleError(dioError.response?.statusCode);
//       case DioExceptionType.sendTimeout:
//         return "Send timeout in connection with API server";
//       case DioExceptionType.connectionError:
//         return "No internet connection";
//       default:
//         return "Something went wrong";
//     }
//   }
//
//   static String _handleError(int? statusCode) {
//     switch (statusCode) {
//       case 400:
//         return 'Bad request';
//       case 404:
//         return 'The requested resource was not found';
//       case 500:
//         return 'Internal server error';
//       default:
//         return 'Oops something went wrong';
//     }
//   }
//
//   @override
//   String toString() => message;
// }
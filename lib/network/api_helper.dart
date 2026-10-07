import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../dialog/confirmation_dialog.dart';
import '../helper/app_navigator.dart';
import '../ui/auth/login/login.dart';
import '../utils/app_strings.dart';
import '../utils/pref_helper.dart';
import 'my_exception.dart';

class ApiResponse<T> {
  final T data;
  final int? statusCode;

  ApiResponse({required this.data, this.statusCode});
}

class ApiHelperLead {
  static Future<ApiResponse<T>> request<T>(
    // BuildContext context,
    Future<Response> Function() apiCall,
    T Function(dynamic data) fromJson,
  ) async {
    try {
      Response response = await apiCall();
      int? statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        return ApiResponse<T>(
          data: fromJson(response.data),
          statusCode: statusCode,
        );
      } else {
        final errorMessage =
            response.data?["message"] ?? "Something went wrong";
       // DialogHelper.alertDialog(context, errorMessageHeading: errorMessage);
        DialogHelper.alertDialog(errorMessageHeading: errorMessage);
        return Future.error(errorMessage);
      }
    } on DioException catch (dioError) {
      debugPrint(
        "DioError catch -------------------------------------------------------- $dioError",
      );

      final errorResponse = MyException.handleDioError(dioError);

      if ( /*dioError.response?.statusCode == 500 || */ dioError
              .response
              ?.statusCode ==
          401) {
        await Prefs.clearAll();
        AppNavigator.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => const LoginScreen()),
        //   (route) => false,
        // );
      } else {
        DialogHelper.alertDialog(
          errorMessageHeading: errorResponse.heading,
          errorMessageTitle: errorResponse.message,
        );
      }

      return Future.error(errorResponse.message);
    } catch (e) {
      debugPrint("Error catch : $e");
      DialogHelper.alertDialog(
        errorMessageHeading: AppStrings.somethingWrong,
      );
      return Future.error(AppStrings.somethingWrong);
    }
  }
}

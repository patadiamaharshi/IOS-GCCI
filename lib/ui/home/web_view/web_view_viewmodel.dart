import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewViewModel extends ChangeNotifier {
  late final WebViewController controller;
  VoidCallback? onPaymentSuccess;
  int progress = 0;
  bool isLoading = true;
  String currentUrl = '';

  ValueChanged<Map<String, dynamic>>? onPaymentResult;

  WebViewViewModel(String paymentUrl, Map<String, dynamic> requestBody) {
    final Uint8List encodedData = Uint8List.fromList(
      utf8.encode(
        requestBody.entries
            .map(
              (e) =>
                  "${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value.toString())}",
            )
            .join("&"),
      ),
    );

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            currentUrl = url;
            notifyListeners();
            debugPrint("Page started: $url");
          },
          onNavigationRequest: (request) async {
            final redirectUrl = request.url;
            debugPrint("Redirect URL: $redirectUrl");
            return NavigationDecision.navigate;
          },
            onPageFinished: (url) async {
              debugPrint("onPageFinished URL: $url");

              if (url.contains("successEvent.php") ||
                  url.contains("failureEvent.php") ||
                  url.contains("notifyEvent.php")) {

                try {
                  final result = await controller.runJavaScriptReturningResult(
                    "document.body.innerText",
                  );

                  String response = result.toString();

                  if (response.startsWith('"') && response.endsWith('"')) {
                    response = response.substring(1, response.length - 1);
                  }

                  response = response
                      .replaceAll(r'\"', '"')
                      .replaceAll(r'\n', '')
                      .replaceAll(r'\\', '')
                      .trim();

                  debugPrint("Payment Response: $response");

                  // Find JSON in the response
                  final start = response.indexOf('{');
                  final end = response.lastIndexOf('}');

                  if (start == -1 || end == -1) {
                    throw Exception("JSON not found in response");
                  }

                  final jsonString = response.substring(start, end + 1);

                  debugPrint("JSON Response: $jsonString");

                  final json = jsonDecode(jsonString);

                  onPaymentResult?.call({
                    "action": json["action"],
                    "message": json["message"],
                  });
                } catch (e) {
                  debugPrint("Payment Parse Error : $e");

                  onPaymentResult?.call({
                    "action": "Failed",
                    "message": "Unable to verify payment.",
                  });
                }
              }
            }
          // onPageFinished: (url) {
          //   debugPrint("onPageFinished URL: $url");
          //
          //   if (url.contains("successEvent.php")) {
          //     onPaymentSuccess?.call();
          //   } /*else if (url.contains("failEvent.php")) {
          //     onPaymentFailed?.call();
          //   }*/
          //   //   if (url.contains('ethanks.php') && !_successHandled) {
          //   //     _successHandled = true;
          //   //
          //   //     Future.delayed(const Duration(seconds: 2), () {
          //   //       onPaymentSuccess?.call();
          //   //     });
          //   //   }
          // },
        ),
      );
    controller.loadRequest(
      Uri.parse(paymentUrl),
      method: LoadRequestMethod.post,
      headers: const {"Content-Type": "application/x-www-form-urlencoded"},
      body: encodedData,
    );
  }
}

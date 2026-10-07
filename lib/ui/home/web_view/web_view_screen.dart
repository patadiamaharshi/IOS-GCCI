import 'package:flutter/material.dart';
import 'package:gcci/ui/home/web_view/web_view_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../common/common_toolbar.dart';

class WebViewScreen extends StatelessWidget {
  final String paymentUrl;

  // final Map<String, String> requestBody;
  final Map<String, dynamic> requestBody;

  const WebViewScreen(this.paymentUrl, this.requestBody, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WebViewViewModel(paymentUrl, requestBody),
      child: const _WebView(),
    );
  }
}

class _WebView extends StatefulWidget {
  const _WebView();

  @override
  State<_WebView> createState() => _WebViewState();
}

class _WebViewState extends State<_WebView> {
  @override
  void initState() {
    super.initState();

    final vm = context.read<WebViewViewModel>();

    vm.onPaymentResult = (result) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context, result);
      }
    };
  /*  vm.onPaymentSuccess = () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context, true);
      }
    };*/
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WebViewViewModel>();

    return  Scaffold(
      appBar: const CommonToolbar(title: 'Payment'),
      body: Column(
        children: [
          /*if (vm.isLoading)
            LinearProgressIndicator(value: vm.progress / 100, minHeight: 2),

          Container(
            width: double.infinity,
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Text(
              vm.currentUrl.isEmpty ? 'Loading...' : vm.currentUrl,
              style: const TextStyle(fontSize: 14),
            ),
          ),*/
          Expanded(child: WebViewWidget(controller: vm.controller)),
        ],
      ),
    );
    //);
  }
}

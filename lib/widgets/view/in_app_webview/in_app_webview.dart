import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flash_note/resources/res_colors.dart';
import 'package:flash_note/widgets/ui/loader.dart';
import 'package:flash_note/widgets/view/in_app_webview/bloc/in_app_webview_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

// To load HTTP resources in your Android app, add 'android:usesCleartextTraffic="true"'
// in the AndroidManifest.xml file.
// iOS allows loading HTTP content by default, but HTTPS is recommended for security.

// Example of basic usage to navigate to the 'InAppWebView' screen with required parameters:
/* Navigator.of(context).pushNamed(
      Routes.InAppWebView,
      arguments: {
      'title': 'Page Title',
      'url': 'http://example.com',
      },
    );*/

class InAppWebView extends StatefulWidget {
  final Map<String, dynamic> webPageData;

  const InAppWebView({super.key, required this.webPageData});

  @override
  State<InAppWebView> createState() => _InAppWebViewState();
}

class _InAppWebViewState extends State<InAppWebView> {
  final InAppWebviewBloc _bloc = InAppWebviewBloc();
  final WebViewController _controller = WebViewController();

  // Allow navigation by default
  FutureOr<NavigationDecision> onNavigationRequest(NavigationRequest request) {
    return NavigationDecision.navigate;
  }

  @override
  void initState() {
    super.initState();
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: onNavigationRequest,
          onProgress: _bloc.setPageProgress,
          onWebResourceError: (error) => _handleWebResourceError(error),
        ),
      );

    String? url = '${widget.webPageData['url']}';
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      // If the URL doesn't have a scheme, assume it's an HTTPS URL
      url = 'https://$url';
    }

    // Load the URL with the corrected scheme
    _controller.loadRequest(Uri.parse(url));
  }

  void _handleWebResourceError(WebResourceError error) {
    // Handle web resource errors. If the error code is -2, indicate a failure.
    if (error.errorCode == -2) {
      _bloc.pageProgress.sink.add(-1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ResColors.white),
        title: Text(
          widget.webPageData['title'] as String? ?? "",
          style: const TextStyle(color: ResColors.white),
        ),
        backgroundColor: ResColors.primary,
        centerTitle: true,
      ),
      body: StreamBuilder<int>(
        stream: _bloc.pageProgress.stream,
        builder: (context, AsyncSnapshot<int> snapshot) {
          if ((snapshot.data ?? 0) < 100) {
            return Center(
              // Display a loading indicator while the page is loading.
              child: Loader(
                size: Size(32.w, 32.w),
                backgroundColor: ResColors.primary,
              ),
            );
          }
          if (snapshot.data?.isNegative ?? false) {
            return const Center(
              // Display a custom error message when the page fails to load.
              child: Text(
                'Failed to load the URL. Custom error message here.',
                style: TextStyle(
                  color: ResColors.primary,
                ),
              ),
            );
          }
          // Display the WebView when the page is loaded.
          return WebViewWidget(controller: _controller);
        },
      ),
    );
  }
}

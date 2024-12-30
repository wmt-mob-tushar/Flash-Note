import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flash_note/networking/api_exceptions.dart';
import 'package:flash_note/redux/actions/store_action.dart';
import 'package:flash_note/redux/app_store.dart';
import 'package:flash_note/utils/api_const.dart';
import 'package:flash_note/utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:snug_logger/snug_logger.dart';

class ApiBaseHelper {
  final Dio _dio = Dio();

  ApiBaseHelper({String? baseUrl}) {
    const Duration timeout = Duration(minutes: 3);
    _dio.options.baseUrl = baseUrl ?? BaseUrl.API;
    _dio.options.connectTimeout = timeout;
    _dio.options.receiveTimeout = timeout;
    if (kDebugMode) {
      _dio.interceptors.add(
        SnugDioLogger(
          requestHeaders: false,
          requestData: false,
          responseHeaders: false,
          responseMessage: true,
          responseData: true,
          logPrint: appDebugPrint,
        ),
      );
    }
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: onRequest,
        onError: onError,
      ),
    );
  }

  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      await checkInternetConnection();
    } catch (e) {
      showNoInternet(e);
    }

    final token = AppStore.store?.state.token;
    if (token != null && token != "") {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers = {...options.headers, ...await ApiConst.getCommonHeader()};

    return handler.next(options); // Continue.
  }

  Future<void> onError(
      DioException dioError, ErrorInterceptorHandler handler) async {
    final Response<dynamic>? response = dioError.response;
    if (response != null) {
      switch (response.statusCode) {
        case 401:
          CommonUtils.showMessage(
            response.data["meta"]["message"] as String,
            type: MessageType.FAILED,
          );
        case 422:
          CommonUtils.showMessage(
            response.data["meta"]["message"] as String,
            type: MessageType.FAILED,
          );
        case 503:
          AppStore.store?.dispatch(
            StoreAction(
              type: ActionType.Reset,
              data: null,
            ),
          );
          CommonUtils.showMessage("Session expired", type: MessageType.FAILED);
          if (AppStore.store?.state.token?.isEmpty ?? true) {
            /*Navigate to login screen from here
          NavigationService.instance.resetToRoute(Routes.Login);*/
          }
        default:
          CommonUtils.showMessage(
            "Something went wrong!",
            type: MessageType.FAILED,
          );
          break;
      }
    }

    return handler.next(dioError); // Continue.
  }

  Future get(String url) async {
    final response = await _dio.get(url);
    return _returnResponse(response);
  }

  Future post(String url, {var body}) async {
    final Response response = await _dio.post(url, data: jsonEncode(body));
    return _returnResponse(response);
  }

  Future postFormData(String url,
      {Map<String, dynamic>? body, onProgress}) async {
    final Response response = await _dio.post(
      url,
      data: FormData.fromMap(body ?? {}),
      onSendProgress: (sent, total) =>
          onProgress != null ? onProgress(sent / total) : null,
    );
    return _returnResponse(response);
  }

  Future put(String url, var body) async {
    final response = await _dio.put(url, data: body);
    return _returnResponse(response);
  }

  Future delete(String url) async {
    final response = await _dio.delete(url);
    return _returnResponse(response);
  }

  void appDebugPrint(Object message) {
    debugPrint(message.toString());
  }

  dynamic _returnResponse(Response response) {
    return response.data;
  }

  Future<void> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (!(result.isNotEmpty && result[0].rawAddress.isNotEmpty)) {
        throw NoInternetException("No Internet Connection");
      }
    } catch (e) {
      throw NoInternetException("No Internet Connection");
    }
  }

  void showNoInternet(e) {
    CommonUtils.showMessage(
      e.toString(),
      type: MessageType.FAILED,
    );
  }
}

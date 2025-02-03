import 'dart:js_interop';

import 'package:snug_logger/snug_logger.dart';
import 'package:uganda_mobile_money/uganda_mobile_money.dart';

abstract class HomeRepository {
  Future<MomoPayResponse> pay(MomoPayRequest request);
}

class HomeImpl extends HomeRepository {
  @override
  Future<MomoPayResponse> pay(MomoPayRequest request) async {
    UgandaMobileMoney client = UgandaMobileMoney(
        secretKey: "FLWSECK_TEST-f6b33af95b76ca09d8861db4430f30fa-X");

    MomoPayResponse response = await client.chargeClient(request);

    return response;
  }
}

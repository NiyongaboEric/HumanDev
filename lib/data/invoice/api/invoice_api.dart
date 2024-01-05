import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/data/constants/request_interceptor.dart';
import 'package:seymo_pay_mobile_application/data/invoice/model/invoice_model.dart';
import 'package:seymo_pay_mobile_application/data/invoice/model/invoice_request.dart';
import 'package:seymo_pay_mobile_application/data/space/model/space_model.dart';

import '../../constants/shared_prefs.dart';

var sl = GetIt.instance;

abstract class InvoiceApi {
  Future<InvoiceModel> getInvoice(String id);
  Future<List<InvoiceModel>> getInvoices();
  Future<List<InvoiceResponse>> createInvoice(InvoiceCreateRequest invoice);
  Future<InvoiceResponse> updateInvoice(InvoiceUpdateRequest invoice, String id);
  Future<InvoiceModel> deleteInvoice(String id);
}

class InvoiceApiImpl implements InvoiceApi {

  @override
  Future<InvoiceModel> getInvoice(String id) async{
    // TODO: implement getInvoice
    var interceptor = sl<RequestInterceptor>();
    var dio = sl<Dio>()..interceptors.add(interceptor);
    var prefs = sl<SharedPreferenceModule>();
    Space? space = prefs.getSpaces().first;
    return dio.get("/space/${space.id}/invoice/$id").then((res) {
      if (res.statusCode == 200) {
        return InvoiceModel.fromJson(res.data);
      } else {
        throw Exception(res.data["message"]);
      }
    });
  }

  @override
  Future<List<InvoiceModel>> getInvoices() async{
    // TODO: implement getInvoices
    var interceptor = sl<RequestInterceptor>();
    var dio = sl<Dio>()..interceptors.add(interceptor);
    var prefs = sl<SharedPreferenceModule>();
    Space? space = prefs.getSpaces().first;
    return dio.get("/space/${space.id}/invoice").then((res) {
      if (res.statusCode == 200) {
        List<dynamic> responseData = res.data; 
        return responseData.map<InvoiceModel>((e) => InvoiceModel.fromJson(e)).toList();
      } else {
        throw Exception(res.data["message"]);
      }
    });
  }
  
  @override
  Future<List<InvoiceResponse>> createInvoice(InvoiceCreateRequest invoice) async{
    // TODO: implement createInvoice
    var interceptor = sl<RequestInterceptor>();
    var dio = sl<Dio>()..interceptors.add(interceptor);
    var prefs = sl<SharedPreferenceModule>();
    Space? space = prefs.getSpaces().first;
    return dio.post("/space/${space.id}/invoice", data: [invoice.toJson()]).then((res) {
      if (res.statusCode == 201) {
        List<dynamic> responseData = res.data; 
        return responseData.map<InvoiceResponse>((e) => InvoiceResponse.fromJson(e)).toList();
      } else {
        throw Exception(res.data["message"]);
      }
    });
  }

  @override
  Future<InvoiceResponse> updateInvoice(InvoiceUpdateRequest invoice, String id) async{
    // TODO: implement updateInvoice
    var interceptor = sl<RequestInterceptor>();
    var dio = sl<Dio>()..interceptors.add(interceptor);
    var prefs = sl<SharedPreferenceModule>();
    Space? space = prefs.getSpaces().first;
    var res = await dio.put("/space/${space.id}/invoice/$id", data: invoice.toJson());
    if (res.statusCode == 200) {
      return InvoiceResponse.fromJson(res.data);
    } else {
      throw Exception(res.data["message"]);
    }
  }

  @override
  Future<InvoiceModel> deleteInvoice(String id) {
    // TODO: implement deleteInvoice
    var interceptor = sl<RequestInterceptor>();
    var dio = sl<Dio>()..interceptors.add(interceptor);
    var prefs = sl<SharedPreferenceModule>();
    Space? space = prefs.getSpaces().first;
    return dio.delete("/space/${space.id}/invoice/$id").then((res) {
      if (res.statusCode == 200) {
        return InvoiceModel.fromJson(res.data);
      } else {
        throw Exception(res.data["message"]);
      }
    });
  }
}

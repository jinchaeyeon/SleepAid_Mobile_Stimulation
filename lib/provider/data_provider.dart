import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sleepaid/data/local/app_dao.dart';
import 'package:sleepaid/data/network/auth_response.dart';
import 'package:sleepaid/data/network/electro_stimulation_parameter_response.dart';
import 'package:sleepaid/network/email_login_service.dart';
import 'package:sleepaid/network/get_electro_stimulations_service.dart';
import 'package:sleepaid/network/parameter_service.dart';
import 'package:sleepaid/network/reset_password_service.dart';
import 'package:sleepaid/util/logger/service_error.dart';
import 'package:sleepaid/util/statics.dart';

import '../data/network/parameter_response.dart';

class DataProvider with ChangeNotifier{
  bool isLoading = false;

  void setLoading(bool showLoading) {
    isLoading = showLoading;
    print("--isLoading: $isLoading");
    notifyListeners();

    if(isLoading){
      Future.delayed(const Duration(seconds: TIMEOUT_SECOND),(){
        isLoading = false;
        notifyListeners();
      });
    }
  }

  ///이메일에 리셋 링크 전송
  Future<Object> sendResetPasswordLinkToEmail(String email) async{
    setLoading(true);
    var result = await PostResetPasswordService(email:email).start();
    setLoading(false);
    return result;
  }

  /// 일시적으로 비트 출력을 정지 / 해제
  Future pauseBinauralBeatState(bool pause) async{

  }

  Future loadParameters() async{
    if(AppDAO.baseData.electroStimulationParameters.isEmpty){
      /// 전기자극 파라미터
      await GetElectroStimulationsService().start().then((result){
        if(result is List<ElectroStimulationParameterResponse>){
          AppDAO.baseData.electroStimulationParameters = result;
        }

        if(kDebugMode){
          AppDAO.baseData.electroStimulationParameters.forEach((parameter) {
            print("stimulation parameter::${parameter.toJson()}");
          });
        }
      });
    }

    if(AppDAO.parameters.isEmpty){
      var result = await GetParameterService().start();
      if(result is List<ParameterResponse>){
        AppDAO.parameters = result;
      }
      print("resule:: $result");
    }
    notifyListeners();
  }

  // Future<Map<String, SleepAnalysisResponse>> getSleepAnalysisList() async{
  //   Map<String, SleepAnalysisResponse> map = {};
  //   await GetSleepConditionsService().start().then((result){
  //     if(result is List<SleepAnalysisResponse>){
  //       for (var response in result) {
  //         map[response.date] = response;
  //         sleepAnalysisMap = map;
  //         notifyListeners();
  //       }
  //     }
  //   });
  //   return map;
  // }

  /// 날짜, 상세목록 각자 호출에서 상세페이지 별 호출로 변경(API 호출 부담 감소 처리)

}


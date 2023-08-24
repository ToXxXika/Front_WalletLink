
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_animations.dart';
import 'budget_d_e_l_e_t_e_model.dart';

export 'budget_d_e_l_e_t_e_model.dart';

class BudgetDELETEWidget extends StatefulWidget {
  const BudgetDELETEWidget({Key? key}) : super(key: key);

  @override
  _BudgetDELETEWidgetState createState() => _BudgetDELETEWidgetState();
}

class _BudgetDELETEWidgetState extends State<BudgetDELETEWidget> {
  late BudgetDELETEModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = {
    'containerOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 200.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 200.ms,
          begin: Offset(0.0, 49.0),
          end: Offset(0.0, 0.0),
        ),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 200.ms,
          begin: Offset(1.0, 0.0),
          end: Offset(1.0, 1.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 50.ms,
          duration: 200.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 50.ms,
          duration: 200.ms,
          begin: Offset(0.0, 51.0),
          end: Offset(0.0, 0.0),
        ),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 50.ms,
          duration: 200.ms,
          begin: Offset(1.0, 0.0),
          end: Offset(1.0, 1.0),
        ),
      ],
    ),
    'listViewOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 90.ms,
          duration: 150.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 90.ms,
          duration: 150.ms,
          begin: Offset(0.0, 26.0),
          end: Offset(0.0, 0.0),
        ),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 90.ms,
          duration: 150.ms,
          begin: Offset(1.0, 0.0),
          end: Offset(1.0, 1.0),
        ),
      ],
    ),
  };
   late double? amount;
   late String? refWallet = '';
    late String? balanceWallet = '';
   void getDataFromSharedPreferences() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();

     String? storedRefWallet = prefs.getString('refWallet');
      String? storedBalanceWallet = prefs.getString('balanceWallet');
      double? amount = prefs.getDouble('amount');

     setState((){

        refWallet = storedRefWallet ?? '';
        balanceWallet = storedBalanceWallet ?? '';
        this.amount = amount ?? 0.0;

     });

   }

  @override
  void initState()  {


    super.initState();
    getDataFromSharedPreferences();
    _model = createModel(context, () => BudgetDELETEModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body:
        Container(
          alignment: Alignment.center,
          child:   QrImageView(
            data: '  $refWallet $balanceWallet $amount',
            size: 320,
            padding: EdgeInsets.zero,
            version: QrVersions.auto,
            gapless: false,
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.circle,
              color: Colors.black,
            ),
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.black,
            ),
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: Size(60,  60),
            ),
            embeddedImage: const AssetImage(
              'assets/images/dollar.png',
            ),
          ),
        ),


    );
  }
}

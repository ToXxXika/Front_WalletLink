import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_link/api/Caller.dart';
import 'package:wallet_link/pages/budget_d_e_l_e_t_e/budget_d_e_l_e_t_e_widget.dart';
import 'package:wallet_link/pages/m_y_budgets/QRScannerOverlay.dart';
import 'package:wallet_link/pages/transaction_a_d_d/transaction_a_d_d_widget.dart';
import 'package:wallet_link/pages/transfer_complete/transfer_complete_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'm_y_budgets_model.dart';

export 'm_y_budgets_model.dart';

class MYBudgetsWidget extends StatefulWidget {
  const MYBudgetsWidget({Key? key}) : super(key: key);

  @override
  _MYBudgetsWidgetState createState() => _MYBudgetsWidgetState();
}

class _MYBudgetsWidgetState extends State<MYBudgetsWidget>
    with TickerProviderStateMixin {
  late MYBudgetsModel _model;

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
  bool isScanCompleted = false;
  bool isFlashOn= false ;
  bool isFrontCamera = false ;
  double? walletBalance = 0.0;
  MobileScannerController controller = MobileScannerController();
  void closeScreen(){
    isScanCompleted = false ;
  }
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MYBudgetsModel());

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }
  void getDatafromSharedPreferences()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? WalletBalance = prefs.getString("balanceWallet");
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }
  Future<void> showInformationDialog(BuildContext context){
    return showDialog(context: context, builder: (context){
      final TextEditingController _textEditingController = TextEditingController();
      return AlertDialog(

        title: const Text("Enter the amount"),
        content: TextField(
          controller: _textEditingController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Enter the amount"),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("Cancel")),
          TextButton(onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? walletBalance = prefs.getString("balanceWallet");
            print(walletBalance);
            double? walletBalanceDouble = double.tryParse(walletBalance ?? '0');
            if(double.tryParse(_textEditingController.text)!<walletBalanceDouble!) {
              prefs.setDouble("amount", double.tryParse(_textEditingController.text)!);
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => BudgetDELETEWidget()));
            }else{
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You don't have enough money in your wallet")));
            }
            }, child: const Text("Confirm"))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            setState(() {
              isFlashOn = !isFlashOn;
            });
             controller.toggleTorch();
          },icon: ValueListenableBuilder<TorchState>(
            valueListenable: controller.torchState,
            builder: (context, state, child) {
             switch (state){
               case TorchState.off:
                 return Icon(Icons.flash_off,color: Colors.white,);
               case TorchState.on:
                 return Icon(Icons.flash_on,color: Colors.yellow,);
             }
            },

          ),
          ),
          IconButton(onPressed: (){
            setState(() {
              isFrontCamera = !isFrontCamera;
            });
            controller.switchCamera();
          },icon: Icon(Icons.camera_front,color: Colors.white))
        ],
      ),
      body: Container(
        color: Color.fromRGBO(26, 31, 36, 1.0),
        width:double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Place the QR code in the frame to scan",style: TextStyle(fontSize: 18,color:Colors.white,fontWeight: FontWeight.bold,letterSpacing: 1),),
                  SizedBox(height: 10,),
                  Text("Scanning will be started automatically",style: TextStyle(fontSize: 16,color: Colors.white),)
                ],
              ),
            )),
            Expanded(
              flex: 4,
               child: Stack(
                 children:[
                   MobileScanner(
                     controller: controller,
                     allowDuplicates: true,
                     onDetect: (barcode,args) async {
                       if(!isScanCompleted){
                         String dataTransaction = barcode.rawValue ?? "---";
                         List<String> parts = dataTransaction.split(" ");
                          Caller caller = Caller();
                          String refWallet = parts[2];
                          String balanceWallet = parts[3];
                          double amount = double.tryParse(parts[4]) ?? 0.0;
                          SharedPreferences prefs =  await SharedPreferences.getInstance();
                          print(parts);
                      print("refWallet : $refWallet");
                      print("balanceWallet : $balanceWallet");
                      print("amount : $amount");
                          prefs.setString('refWalletT', refWallet);
                          prefs.setString('balanceWalletT', balanceWallet);
                          prefs.setDouble("amountT", amount);
                         //TODO : function here
                        // print(dataTransaction);

                         if(await caller.peer2peer(refWallet, prefs.getString("refWallet").toString(), amount , context)){
                           isScanCompleted = true ;
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>(TransferCompleteWidget())));
                         }

                       }
                     },
                   ),
                     QRScannerOverlay(overlayColour: Color.fromRGBO(26, 31, 36, 1.0),)
                 ]
               )
            ),
            Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text("Once the QR code is scanned we will redirect you to the transaction page to complete the transaction",textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1
                    ),
                  ),
            ),

            ),
            Expanded(child: Container(
              alignment:Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed:()async{
                  await showInformationDialog(context);
                },
                backgroundColor: FlutterFlowTheme.of(context).tertiary,
                elevation: 8,
                child: Icon(
                  Icons.qr_code_rounded,
                  color:FlutterFlowTheme.of(context).textColor,
                  size: 32,
                ),
              ),
            ))
          ],
        ),

      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:alcon_flex_nda/app_ui/app_ui.dart';
import 'package:alcon_flex_nda/widgets/widgets.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignaturePadDialog extends StatefulWidget {
  const SignaturePadDialog({
    required this.onSignedFunction,
    super.key,
  });

  final VoidCallback onSignedFunction;

  @override
  State<SignaturePadDialog> createState() => _SignaturePadDialogState();
}

class _SignaturePadDialogState extends State<SignaturePadDialog> {
  GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Dialog(
            insetPadding: const EdgeInsets.all(5.0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Container(
              width: (constraints.maxWidth < 800) ? constraints.maxWidth : 600,
              height: (constraints.maxWidth < 800) ? 600 : 400,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                  ),
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Add Signature",
                              style: UITextStyle.headline4.copyWith(color: AppColors.lightBlack),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child:GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.close_outlined,
                                  color: AppColors.mediumEmphasisSurface,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 300,
                        height: 200,
                        child: SfSignaturePad(
                          key: signatureGlobalKey,
                          backgroundColor: AppColors.lightBlue.withAlpha(50),
                          strokeColor: AppColors.black,
                          onDrawEnd: () => print('drawEnd'),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Container(
                            width: 150,
                            child: AppButton.crystalBlue(
                              child: Text(
                                "Clear Signature",
                              ),
                              onPressed: _handleClearButtonPressed,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Container(
                            width: 150,
                            child: AppButton.crystalBlue(
                              child: Text(
                                "Sign and Review",
                              ),
                              onPressed: () => widget.onSignedFunction.call(),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          );
        }
    );
  }
}

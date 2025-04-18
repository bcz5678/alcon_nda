import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:alcon_flex_nda/app.dart' show AppButton, NDAFormBloc, NDAFormState, NDASavePdf, PdfSubmissionStatus;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SubmissionDialog extends StatefulWidget {
  const SubmissionDialog({
    required this.contextNDABloc,
    required this.pdfViewerController,
    super.key,
  });

  final BuildContext contextNDABloc;
  final PdfViewerController pdfViewerController;


  @override
  State<SubmissionDialog> createState() => _SubmissionDialogState();
}

class _SubmissionDialogState extends State<SubmissionDialog> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('postFrameBuild');
      Future.delayed(Duration(milliseconds: 500), (){
        saveAndSubmitPdf();
      });
    });
  }

  Future<void> saveAndSubmitPdf() async {
    print('in saveAndSubmitPdf');

    //Save Pdf to Bloc. If no errors, the BLoc will automatically submit to the Drive
    widget.contextNDABloc.read<NDAFormBloc>().add(NDASavePdf(widget.pdfViewerController));


  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return BlocBuilder<NDAFormBloc, NDAFormState>(
          builder: (context, state) {
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
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Container(

                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "1. Building Signed PDF",
                                  ),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(
                                        'images/blue_circle_progress.gif'
                                      )
                                  ),
                                  /*
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 30.0,
                                  ),

                                   */
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "2. Saving PDF",
                                  ),
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 30.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: 150,
                              child: GestureDetector(
                                  child: Text(
                                      "Back to Form",
                                      style: UITextStyle.headline6.copyWith(
                                        decoration: TextDecoration.underline,
                                        fontWeight: AppFontWeight.regular,
                                      )
                                  ),
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  }
                              )
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: SizedBox(),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Container(
                                width: 150,
                                child: AppButton.crystalBlue(
                                  child: Text(
                                    "Reset Form",
                                  ),
                                  onPressed: null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          );
  },
);
        }
    );
  }
}

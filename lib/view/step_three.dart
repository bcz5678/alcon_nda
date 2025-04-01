import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:alcon_flex_nda/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alcon_flex_nda/bloc/nda_form_bloc.dart';
import 'package:alcon_flex_nda/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_pdfviewer_web/pdfviewer_web.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class StepThree extends StatefulWidget {
  const StepThree({super.key});

  @override
  State<StepThree> createState() => _StepThreeState();
}

class _StepThreeState extends State<StepThree> {
  Uint8List? _documentBytes;
  late PdfViewerController _pdfViewerController;
  late bool _isSigningEnabled = false;


  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    addScrollListener();
    super.initState();

    // Load the PDF document from the asset.

    _generateAsset().then((List<int> bytes) async {
      setState(() {
        _documentBytes = Uint8List.fromList(bytes);
      });
    });

  }

  // Read the asset file and return the bytes.
  Future<List<int>> _generateAsset() async {
    var state = context.read<NDAFormBloc>().state;

    final List<int> data = await PdfNdaApi(
      guestData: state.guestData!,
      eventData: state.eventData!,
      clientData: state.clientData!,
    ).generateNDA();

    return data;
  }

  void addScrollListener() {
    _pdfViewerController.addListener(() {
      if(_pdfViewerController.pageNumber == _pdfViewerController.pageCount) {
        setState(() {
          _isSigningEnabled = true;
        });
      }
    });
  }

  void onPressedFooterFunction() {
    var state = context.read<NDAFormBloc>().state;
    //print(selectedExperiencesReturnList(_selectedExperiencesIndexes));
  }

  void onSignedFunctionParent() {
    print('onSignedFunctionParent signed');
  }

  void pressSignatureButton() {
    showDialog(
      context: context,
      builder: (context) {
        return SignaturePadDialog(
          contextNDABloc: context,
          onSignedFunction: onSignedFunctionParent,
        );
      },
      barrierColor: Color.fromRGBO(0, 0, 0, 0.2),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 100,
        child: StickyFooter(
          currentStep: 3,
          onPressedFunction: onPressedFooterFunction,
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Center(
              child: Container(
                  width: MediaQuery.of(context).size.width >= 1000
                      ? 1000
                      : constraints.maxWidth,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
                          child: const FractionallySizedBox(
                            widthFactor: 0.20,
                            child: Image(
                                image: AssetImage('images/alcon-logo-2019.png')
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Text(
                            "Please Review the NDA Below and Sign",
                            style: GoogleFonts.notoSans(
                              textStyle: TextStyle(
                                color: Colors.black.withAlpha(175),
                                fontSize: 32.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Expanded(
                          child: _documentBytes != null
                          ? SfPdfViewer.memory(
                            _documentBytes!,
                            controller: _pdfViewerController,
                            scrollDirection: PdfScrollDirection.vertical,
                            initialZoomLevel: 1.0,
                            onTextSelectionChanged: null,
                          )
                          : const Center(
                              child: CircularProgressIndicator(
                              color: AppColors.crystalBlue,
                              ),
                            ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            width: double.infinity / 3,
                            child: AppButton.crystalBlue(
                              child: Text(
                                "Sign PDF",
                              ),
                              onPressed: _isSigningEnabled
                                ? pressSignatureButton
                                : null,
                            ),
                          ),
                        ),
                      ]
                  )
              ),
            );
          }
      ),
    );
  }
}




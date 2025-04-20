import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:alcon_flex_nda/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alcon_flex_nda/bloc/nda_form_bloc.dart';
import 'package:alcon_flex_nda/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:app_ui/app_ui.dart';

class StepThree extends StatefulWidget {
  const StepThree({super.key});

  @override
  State<StepThree> createState() => _StepThreeState();
}

class _StepThreeState extends State<StepThree> {
  Uint8List? _documentBytes;
  late PdfViewerController _pdfViewerController;
  late bool _isSigningEnabled = false;

  //late PdfNdaApi pdfNdaApi;


  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();

   // pdfNdaApi = generatePdfNdaApi();

    // Load the PDF document from the asset.
    /*
    _generateAsset(pdfNdaApi).then((List<int> bytes) async {
      setState(() {
        _documentBytes = Uint8List.fromList(bytes);
      });
    });
     */
  }

  PdfNdaApi generatePdfNdaApi() {
    var state = context.read<NDAFormBloc>().state;

    return PdfNdaApi(
      guestData: state.guestData!,
      eventData: state.eventData!,
      clientData: state.clientData!,
    );
  }

  // Read the asset file and return the bytes.
  Future<List<int>> _generateAsset(PdfNdaApi pdfNdaApi) async {
    final List<int> data = await pdfNdaApi.generateNDA();

    return data;
  }

  Future<void> onPressedFooterFunction() async {

    print('step_three -> onPressedFooterFunction -> Entry');

    showDialog(
      context: context,
      builder: (context) {
        return SubmissionDialog(
          contextNDABloc: context,
          pdfViewerController: _pdfViewerController,
        );
      },
      barrierColor: Color.fromRGBO(0, 0, 0, 0.2),
      barrierDismissible: false,
    );
  }

  void onBackFooterFunction() {
     _pdfViewerController.dispose();
 }

  void onSignedFunctionParent() {
    setState(() {
      _isSigningEnabled = true;
    });
  }

  void onPdfLoaded() {
    print(_pdfViewerController.getFormFields());
    _pdfViewerController.importFormData(
      inputBytes,
      DataFormat.json
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<NDAFormBloc>().state;

    return Scaffold(
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 100,
        child: StickyFooter(
          currentStep: 3,
          onPressedFunction: onPressedFooterFunction,
          onBackFunction: onBackFooterFunction,
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Center(
              child: Container(
                  width: MediaQuery.of(context).size.width >= 1000
                      ? 1000
                      : constraints.maxWidth,
                  child: Padding(
                    padding:  MediaQuery.of(context).size.width >= 1000
                        ? const EdgeInsets.all(0.0)
                        : const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
                            child: FractionallySizedBox(
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
                           /*SfPdfViewer.memory(
                              _documentBytes!,
                              contextBloc: context,
                              controller: _pdfViewerController,
                              scrollDirection: PdfScrollDirection.vertical,
                              initialZoomLevel: 1.0,
                              onTextSelectionChanged: null,
                            ) */
                              child: SfPdfViewer.asset(
                                'assets/files/alcon_base_template_clean.pdf',
                                contextBloc: context,
                                controller: _pdfViewerController,
                                scrollDirection: PdfScrollDirection.vertical,
                                initialZoomLevel: 1.0,
                                onTextSelectionChanged: null,
                                onDocumentLoaded: (details) => onPdfLoaded(),
                              ),
                          ),
                          /*
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              width: double.infinity / 3,
                              child: AppButton.crystalBlue(
                                child: state.guestData?.signature != null
                                ? Text(
                                   "Edit Signature"
                                  )
                                : Text(
                                  "Sign PDF",
                                ),
                                onPressed: _isSigningEnabled
                                  ? pressSignatureButton
                                  : null,
                              ),
                            ),
                          ),
                          */
                        ]
                    ),
                  )
              ),
            );
          }
      ),
    );
  }
}




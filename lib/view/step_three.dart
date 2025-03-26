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
  GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void onPressedFooterFunction() {
    var state = context.read<NDAFormBloc>().state;
    //print(selectedExperiencesReturnList(_selectedExperiencesIndexes));
  }

  void onSignedFunctionParent() {
    print('onSignedFunctionParent signed');
  }

  void pressSignatureButton() {
    if(kDebugMode) {
      print('game_menu -> pressSignButton -> pressed');
    }

    showDialog(
      context: context,
      builder: (context) {
        return SignaturePadDialog(
          onSignedFunction: onSignedFunctionParent,
        );
      },
      barrierColor: Color.fromRGBO(255, 255, 255, 0.7),
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
                            "Please Review the NDA below and Sign",
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Container(
                            width: double.infinity / 3,
                            child: AppButton.crystalBlue(
                              child: Text(
                                "Sign PDF",
                              ),
                              onPressed: pressSignatureButton,
                            ),
                          ),
                        ),
                        PdfContainer(),
                      ]
                  )
              ),
            );
          }
      ),
    );
  }
}


class PdfContainer extends StatefulWidget {
  const PdfContainer({super.key});

  @override
  State<PdfContainer> createState() => _PdfContainerState();
}

class _PdfContainerState extends State<PdfContainer> {
  final Map<String, Uint8List> _signedFields = <String, Uint8List>{};
  PdfDocument? _loadedDocument;
  Uint8List? _documentBytes;
  bool _canCompleteSigning = false;
  bool _canShowToast = false;

  @override
  void initState() {
    super.initState();
    // Load the PDF document from the asset.
    _readAsset('alcon_base_template.pdf').then((List<int> bytes) async {
      setState(() {
        _documentBytes = Uint8List.fromList(bytes);
      });
    });
  }

  // Read the asset file and return the bytes.
  Future<List<int>> _readAsset(String name) async {
    final ByteData data = await rootBundle.load('assets/files/$name');
    return data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: _documentBytes != null
            ? SfPdfViewer.memory(
          _documentBytes!,
          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
            // Store the loaded document to access the form fields.
            _loadedDocument = details.document;
            // Clear the signed fields when the document is loaded.
            //_signedFields.clear();
          },
          onFormFieldValueChanged:
              (PdfFormFieldValueChangedDetails details) {
            // Update the signed fields when the form field value is changed.
            if (details.formField is PdfSignatureFormField) {
              final PdfSignatureFormField signatureField =
              details.formField as PdfSignatureFormField;
              if (signatureField.signature != null) {
                _signedFields[details.formField.name] =
                signatureField.signature!;
                setState(() {
                  _canCompleteSigning = true;
                });
              } else {
                _signedFields.remove(details.formField.name);
                setState(() {
                  _canCompleteSigning = false;
                });
              }
            }
          },
        )
            : const Center(
          child: CircularProgressIndicator(
            color: AppColors.crystalBlue,
          ),
        ),
      ),
    );
  }
}


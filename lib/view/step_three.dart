import 'package:flutter/services.dart';

import 'package:alcon_flex_nda/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alcon_flex_nda/bloc/nda_form_bloc.dart';
import 'package:alcon_flex_nda/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class StepThree extends StatefulWidget {
  const StepThree({super.key});

  @override
  State<StepThree> createState() => _StepThreeState();
}

class _StepThreeState extends State<StepThree> {
  GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  late PdfDocument _ndaDocument;

  @override
  void initState() {
    super.initState();
    loadPdfDocument();

  }

  Future<void> loadPdfDocument() async {
    final ndaDocumentBase = await rootBundle.load('files/alcon_base_template.pdf');
    final ndaDocumentBytes = ndaDocumentBase.buffer.asUint8List();
    setState(() {
      _ndaDocument = PdfDocument(inputBytes: ndaDocumentBytes);
    });

    for (var index = 0; index < _ndaDocument.form.fields.count; index++ ) {
      print(_ndaDocument.form.fields[index]);
    }
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void onPressedFooterFunction() {
    var state = context.read<NDAFormBloc>().state;
    //print(selectedExperiencesReturnList(_selectedExperiencesIndexes));
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
                        Expanded(
                          child: CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
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
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                                  child: Container(
                                    width: double.infinity / 3,
                                    child: AppButton.crystalBlue(
                                      child: Text(
                                        "Clear ",
                                      ),
                                      onPressed: _handleClearButtonPressed,
                                    ),
                                  ),
                                ),
                              )
                            ],
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

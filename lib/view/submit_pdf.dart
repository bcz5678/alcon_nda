import 'package:alcon_flex_nda/app.dart' show StickyFooter, AppButton;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alcon_flex_nda/bloc/nda_form_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class SubmitPdf extends StatefulWidget {
  const SubmitPdf({
    required this.pdfViewerController,
    super.key
  });

  final PdfViewerController pdfViewerController;

  @override
  State<SubmitPdf> createState() => _SubmitPdfState();
}

class _SubmitPdfState extends State<SubmitPdf> {


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
    context.read<NDAFormBloc>().add(NDASaveAndSubmitPdf(widget.pdfViewerController));
  }


  void onPressedFooterFunction() {
      context.go('/step_three');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 100,
        child: StickyFooter(
          currentStep: 4,
          onPressedFunction: onPressedFooterFunction,
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Center(
              child: BlocBuilder<NDAFormBloc, NDAFormState>(
                builder: (context, state) {
                  return Container(
                    width: MediaQuery.of(context).size.width >= 1000
                        ? 1000
                        : constraints.maxWidth,
                    child: Padding(
                      padding: MediaQuery.of(context).size.width >= 1000
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
                           Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    "1. Building Signed PDF",
                                    style: UITextStyle.headline4,
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  child: [PdfSubmissionStatus.waiting,
                                    PdfSubmissionStatus.building].contains(state.pdfSubmissionStatus)
                                      ? CircularProgressIndicator(
                                    color: AppColors.crystalBlue,
                                  )
                                      : Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 30.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    "2. Saving PDF",
                                    style: UITextStyle.headline4,
                                  ),
                                ),
                                [PdfSubmissionStatus.waiting,
                                  PdfSubmissionStatus.building].contains(state.pdfSubmissionStatus)
                                    ? SizedBox()
                                    : state.pdfSubmissionStatus == PdfSubmissionStatus.submitting
                                    ? CircularProgressIndicator(
                                  color: AppColors.crystalBlue,
                                )
                                    : Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 30.0,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: state.pdfSubmissionStatus != PdfSubmissionStatus.submitted
                                      ? Container(
                                      width: 200,
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
                                  )
                                      : SizedBox(),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                                    child: state.pdfSubmissionStatus == PdfSubmissionStatus.submitted
                                        ? Container(
                                      width: 150,
                                      child: AppButton.crystalBlue(
                                        child: Text(
                                          "Reset Form",
                                        ),
                                        onPressed: null,
                                      ),
                                    )
                                        : SizedBox(),
                                  ),
                                ),
                              ],
                            ),
                          ]
                      ),
                    )
                  );
                },
              ),
            );
          }
      ),
    );
  }
}






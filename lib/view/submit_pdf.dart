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
  }

  void resetForm() {

    context.read<NDAFormBloc>().add(NDAResetApp());

    context.goNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
                                  child: FractionallySizedBox(
                                    widthFactor: 0.50,
                                    child: Image(
                                        image: AssetImage('images/alcon-logo-2019.png')
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                             flex: 3,
                             child: Container(
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Row(
                                     mainAxisSize: MainAxisSize.min,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       Padding(
                                         padding: const EdgeInsets.all(20.0),
                                         child: Text(
                                             "Building Signed PDF",
                                             style: UITextStyle.headline1.copyWith(
                                               color: [PdfSubmissionStatus.waiting,
                                                 PdfSubmissionStatus.building].contains(state.pdfSubmissionStatus)
                                                   ? AppColors.black
                                                   : AppColors.grey,
                                             )
                                         ),
                                       ),
                                       Container(
                                         width: 50,
                                         height: 50,
                                         child: [PdfSubmissionStatus.waiting,
                                           PdfSubmissionStatus.building].contains(state.pdfSubmissionStatus)
                                             ? CircularProgressIndicator(
                                           color: AppColors.crystalBlue,
                                         )
                                             : Icon(
                                           Icons.check_circle,
                                           color: AppColors.crystalBlue,
                                           size: 50.0,
                                         ),
                                       ),
                                     ],
                                   ),
                                   Row(
                                     mainAxisSize: MainAxisSize.min,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       Padding(
                                         padding: const EdgeInsets.all(20.0),
                                         child: Text(
                                             "Saving PDF",
                                             style: UITextStyle.headline1.copyWith(
                                               color: [PdfSubmissionStatus.waiting,
                                                 PdfSubmissionStatus.building,
                                                 PdfSubmissionStatus.submitted].contains(state.pdfSubmissionStatus)
                                                   ? AppColors.grey
                                                   : AppColors.black,
                                             )
                                         ),
                                       ),
                                       Container(
                                         width: 50,
                                         height: 50,
                                         child: [PdfSubmissionStatus.waiting,
                                         PdfSubmissionStatus.building].contains(state.pdfSubmissionStatus)
                                           ? SizedBox()
                                           : state.pdfSubmissionStatus == PdfSubmissionStatus.submitting
                                           ? CircularProgressIndicator(
                                           color: AppColors.crystalBlue,
                                         )
                                             : Icon(
                                           Icons.check_circle,
                                           color: AppColors.crystalBlue,
                                           size: 50.0,
                                         ),
                                       ),
                                     ],
                                   ),
                                   if(state.pdfSubmissionStatus == PdfSubmissionStatus.submitted)...[
                                     Row(
                                       mainAxisSize: MainAxisSize.min,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         Padding(
                                           padding: const EdgeInsets.all(20.0),
                                           child: Text(
                                               "NDA Successfully Submitted",
                                               style: UITextStyle.headline1.copyWith(
                                                 color: AppColors.green,
                                               )
                                           ),
                                         ),
                                       ],
                                     ),
                                   ] else if(state.pdfSubmissionStatus == PdfSubmissionStatus.submissionError)...[
                                     Row(
                                       mainAxisSize: MainAxisSize.min,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         Padding(
                                           padding: const EdgeInsets.all(20.0),
                                           child: Text(
                                               "There was an error submitting  your form.",
                                               style: UITextStyle.headline3.copyWith(
                                                 color: AppColors.red,
                                                 height: 0.5,
                                               )
                                           ),
                                         ),
                                       ],
                                     ),
                                     Row(
                                       mainAxisSize: MainAxisSize.min,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         Padding(
                                           padding: const EdgeInsets.all(20.0),
                                           child: Text(
                                               "Please Try Again",
                                               style: UITextStyle.headline3.copyWith(
                                                 color: AppColors.red,
                                                 height: 0.5,
                                               )
                                           ),
                                         ),
                                       ],
                                     ),
                                   ]else...[
                                     SizedBox(),
                                   ]
                                 ],
                               ),
                             ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if(state.pdfSubmissionStatus != PdfSubmissionStatus.submitted)...[
                                      Container(
                                        child: GestureDetector(
                                          child: Text(
                                              "Back to Form",
                                              style: UITextStyle.headline6.copyWith(
                                                decoration: TextDecoration.underline,
                                                fontWeight: AppFontWeight.regular,
                                              )
                                          ),
                                          onTap: () {
                                            context.goNamed('stepThree');
                                          }
                                        )
                                      )
                                    ] else...[
                                      Container(
                                        width: constraints.maxWidth * .5,
                                        child: AppButton.crystalBlue(
                                          child: Text(
                                            "Reset Form",
                                            style: UITextStyle.button,
                                          ),
                                          onPressed: resetForm,
                                        ),
                                      )
                                    ]
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(),
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






import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:alcon_flex_nda/app_ui/app_ui.dart';
import 'package:alcon_flex_nda/widgets/widgets.dart' show AppButton;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alcon_flex_nda/bloc/nda_form_bloc.dart';

class StickyFooter extends StatefulWidget {
  const StickyFooter({
    required this.currentStep,
    required this.onPressedFunction,
    super.key
  });

  final int currentStep;
  final VoidCallback onPressedFunction;

  @override
  State<StickyFooter> createState() => _StickyFooterState();
}

class _StickyFooterState extends State<StickyFooter> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<NDAFormBloc>().state;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: LinearProgressBar(
                      maxSteps: 4,
                      progressType: LinearProgressBar.progressTypeLinear,
                      currentStep: widget.currentStep,
                      progressColor: AppColors.crystalBlue,
                      backgroundColor: AppColors.pastelGrey,
                      borderRadius: BorderRadius.circular(10), //  NEW
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 150,
                        child: (widget.currentStep > 1)
                          ?  GestureDetector(
                              child: Text(
                                "Back",
                                style: UITextStyle.headline6.copyWith(
                                  decoration: TextDecoration.underline,
                                  fontWeight: AppFontWeight.regular,
                                )
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              }
                            )
                          : SizedBox(),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Container(
                        width: 150,
                        child: AppButton.crystalBlue(
                          key: const Key('formInput_step1_nextStepButton'),
                          onPressed:  state.fullNameInput!.isPure ||
                                      state.address1Input!.isPure ||
                                      state.cityInput!.isPure ||
                                      state.stateAbbrInput!.isPure ||
                                      state.zipcodeInput!.isPure
                              ? null
                              : widget.onPressedFunction,
                          child: state.formzSubmissionStatus!.isInProgress
                              ? const SizedBox.square(
                            dimension: 24,
                            child: CircularProgressIndicator(),
                          )
                              : Text("Next Step"),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}

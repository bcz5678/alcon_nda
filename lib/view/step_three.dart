import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alcon_flex_nda/bloc/nda_form_bloc.dart';
import 'package:alcon_flex_nda/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class StepThree extends StatefulWidget {
  const StepThree({super.key});

  @override
  State<StepThree> createState() => _StepThreeState();
}

class _StepThreeState extends State<StepThree> {

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
                            widthFactor: 0.35,
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

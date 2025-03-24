import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alcon_flex_nda/bloc/nda_form_bloc.dart';
import 'package:alcon_flex_nda/widgets/widgets.dart';

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
          currentStep: 2,
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
                            "Please Select the Experiences You May Attend",
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
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (_selectedExperiencesIndexes.contains(index)) {
                                              _selectedExperiencesIndexes.remove(index);
                                            } else {
                                              _selectedExperiencesIndexes.add(index);
                                            }
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: _selectedExperiencesIndexes.contains(index)
                                                  ? AppColors.crystalBlue.withAlpha(50)
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: _selectedExperiencesIndexes.contains(index)
                                                    ? AppColors.focusedBorder
                                                    : Colors.grey,
                                              )),
                                          height: 100,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(15.0),
                                                    child: Container(
                                                      width: 25,
                                                      child: _selectedExperiencesIndexes.contains(index)
                                                          ? Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(50),
                                                            color: AppColors.blueDress,
                                                          ),
                                                          child: const Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                          ))
                                                          : SizedBox(),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Here is the Title ${index + 1}",
                                                            style: UITextStyle.headline4,
                                                          ),
                                                          Text("Subtitle ${index + 1}")
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  // 40 list items
                                  childCount: 8,
                                ),
                              ),
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

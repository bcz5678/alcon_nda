import 'package:alcon_flex_nda/app.dart' show StepThree, StickyFooter;
import 'package:alcon_flex_nda/data/data.dart';
import 'package:alcon_flex_nda/widgets/app_experiences_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alcon_flex_nda/bloc/nda_form_bloc.dart';
import 'package:app_ui/app_ui.dart';


class StepTwo extends StatefulWidget {
  const StepTwo({super.key});

  @override
  State<StepTwo> createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  late List<ExperienceData> _experiencesList;
  late List<int> _selectedExperiencesIndexes;
  final ScrollController _controller = ScrollController();
  late bool _selectAllState = false;

  @override
  void initState() {
    _selectedExperiencesIndexes = [];
    _experiencesList = [];
    buildExperiencesList();
    initializeSelectedExperiences();
    super.initState();
  }


  void onPressedFooterFunction() {
    var state = context.read<NDAFormBloc>().state;

    if(state.selectedExperiences!.length > 0) {
      context.read<NDAFormBloc>()
          .add(NDAFormExperiencesSubmitted()
      );

      context.go('/step_three');
    }
  }

  Future<void> buildExperiencesList() async {
    context.read<NDAFormBloc>().add(NDAGetAllExperiencesData());
    setState(() {
      _experiencesList = context.read<NDAFormBloc>().state.experiencesData!;
    });
  }

  Future<void> initializeSelectedExperiences() async {
    List<ExperienceData>? returnSelected = context.read<NDAFormBloc>().state.guestData!.experiencesSelected;
    setState(() {
      if (returnSelected != null && returnSelected.isNotEmpty) {
        for (var index = 0; index < _experiencesList.length; index++) {
          if(returnSelected.contains(_experiencesList[index])) {
            _selectedExperiencesIndexes.add(index);
          }
        }
      } else {
        selectAllExperiences();
      }
    });
}


  Future<void> selectAllExperiences() async {
    List<int>returnList = [];
    for(var index = 0; index < _experiencesList.length; index++) {
      returnList.add(index);
    }

    context.read<NDAFormBloc>().add(NDAFormExperienceSelectAll());
    setState(() {
      _selectedExperiencesIndexes = returnList;
      _selectAllState = !_selectAllState;
    });
  }

  Future<void> unselectAllExperiences() async {
    context.read<NDAFormBloc>().add(NDAFormExperienceUnselectAll());
    setState(() {
      _selectAllState = !_selectAllState;
      _selectedExperiencesIndexes = [];
    });
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                      child: Row(
                        children: [
                          AppExperiencesCheckbox(
                              value:  _selectAllState,
                              onChanged: (value) {
                                if(_selectAllState == true) {
                                  unselectAllExperiences();
                                } else {
                                  selectAllExperiences();
                                }
                              }
                          ),
                          Text(
                            "Select All",
                            style: UITextStyle.labelLarge,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return BlocBuilder<NDAFormBloc, NDAFormState>(
                                  builder: (context, state) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (_selectedExperiencesIndexes.contains(index)) {
                                              _selectedExperiencesIndexes.remove(index);
                                              context.read<NDAFormBloc>()
                                                .add(NDAFormExperienceUnselected(
                                                  state.experiencesData![index]
                                                )
                                              );
                                              _selectAllState = false;
                                            } else {
                                              _selectedExperiencesIndexes.add(index);
                                              context.read<NDAFormBloc>()
                                                  .add(NDAFormExperienceSelected(
                                                  state.experiencesData![index]
                                              )
                                              );
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
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 5.0,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            state.experiencesData![index].name,
                                                            style: UITextStyle.headline4,
                                                          ),
                                                          if(state.experiencesData![index].description != null)
                                                            Text(state.experiencesData![index].description!)
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
                ),
              )
            ),
          );
        }
      ),
    );
  }
}






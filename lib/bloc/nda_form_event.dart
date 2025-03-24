part of 'nda_form_bloc.dart';

abstract class NDAFormEvent  extends Equatable{
  const NDAFormEvent();
}

class NDAGetEventData extends NDAFormEvent{
  const NDAGetEventData();

  @override
  List<Object?> get props => [];
}

class NDAGetAllExperiencesData extends NDAFormEvent{
  const NDAGetAllExperiencesData();

  @override
  List<Object?> get props => [];
}

class NDAGetClientData extends NDAFormEvent{
  const NDAGetClientData();

  @override
  List<Object?> get props => [];
}


class NDAFormFullNameChanged extends NDAFormEvent{
  const NDAFormFullNameChanged(this.fullName);

  final String fullName;

  @override
  List<Object?> get props => [fullName];
}

class NDAFormTitleChanged extends NDAFormEvent{
 const NDAFormTitleChanged(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

class NDAFormStepSubmitted extends NDAFormEvent{
  const NDAFormStepSubmitted({required this.nextStep});

  final NDAFormStep nextStep;

@override
List<Object?> get props => [nextStep];
}
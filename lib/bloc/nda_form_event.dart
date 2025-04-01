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

class NDAFormAddress1Changed extends NDAFormEvent{
  const NDAFormAddress1Changed(this.address_1);

  final String address_1;

  @override
  List<Object?> get props => [address_1];
}

class NDAFormAddress2Changed extends NDAFormEvent{
  const NDAFormAddress2Changed(this.address_2);

  final String address_2;

  @override
  List<Object?> get props => [address_2];
}

class NDAFormCityChanged extends NDAFormEvent{
  const NDAFormCityChanged(this.city);

  final String city;

  @override
  List<Object?> get props => [city];
}

class NDAFormStateAbbrChanged extends NDAFormEvent{
  const NDAFormStateAbbrChanged(this.state_abbr);

  final String state_abbr;

  @override
  List<Object?> get props => [state_abbr];
}

class NDAFormZipcodeChanged extends NDAFormEvent{
  const NDAFormZipcodeChanged(this.zipcode);

  final String zipcode;

  @override
  List<Object?> get props => [zipcode];
}


class NDAFormDetailsSubmitted extends NDAFormEvent{
  const NDAFormDetailsSubmitted();

  @override
  List<Object?> get props => [];
}

class NDAFormExperiencesSubmitted extends NDAFormEvent{
  const NDAFormExperiencesSubmitted();

  @override
  List<Object?> get props => [];
}

class NDAFormExperienceSelected extends NDAFormEvent {
  const NDAFormExperienceSelected(this.experience);

  final ExperienceData experience;

  @override
  List<Object?> get props => [experience];
}

class NDAFormExperienceUnselected extends NDAFormEvent {
  const NDAFormExperienceUnselected(this.experience);

  final ExperienceData experience;

  @override
  List<Object?> get props => [experience];
}

class NDAFormExperienceSelectAll extends NDAFormEvent {
  const NDAFormExperienceSelectAll();


  @override
  List<Object?> get props => [];
}

class NDAFormExperienceUnselectAll extends NDAFormEvent {
  const NDAFormExperienceUnselectAll();


  @override
  List<Object?> get props => [];
}

class NDAFormAddSignature extends NDAFormEvent {
  const NDAFormAddSignature(this.signature);

  final Uint8List signature;

  @override
  List<Object?> get props => [signature];
}
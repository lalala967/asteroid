part of 'lang_bloc.dart';

sealed class LangEvent extends Equatable {
  const LangEvent();

  @override
  List<Object> get props => [];
}

class LanguageAlertEvent extends LangEvent {
  const LanguageAlertEvent(this.selectedLanguage);
  final String selectedLanguage;

  @override
  List<Object> get props => [selectedLanguage];
}

class LanguageSelectedEvent extends LangEvent {
  const LanguageSelectedEvent(this.selectedLanguage);
  final String selectedLanguage;

  @override
  List<Object> get props => [selectedLanguage];
}

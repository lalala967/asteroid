import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:tech_pirates/features/voice_guidance/voice_assistance.dart';

part 'lang_event.dart';
part 'lang_state.dart';

class LangBloc extends Bloc<LangEvent, LangState> {
  LangBloc() : super(LangInitial()) {
    on<LanguageAlertEvent>(selectLanguageVoice);
    on<LanguageSelectedEvent>(selectedLanguage);
  }

  void selectLanguageVoice(LanguageAlertEvent event, Emitter emit) {
    VoiceAssistance.speak(event.selectedLanguage, "kn-IN");
  }

  void selectedLanguage(LanguageSelectedEvent event, Emitter emit) {
    emit(LanguageSelectedState(selectedLanguage: event.selectedLanguage));
  }
}

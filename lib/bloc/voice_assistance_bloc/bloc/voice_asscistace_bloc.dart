import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'voice_asscistace_event.dart';
part 'voice_asscistace_state.dart';

class VoiceAsscistaceBloc
    extends Bloc<VoiceAsscistaceEvent, VoiceAsscistaceState> {
  VoiceAsscistaceBloc() : super(VoiceAsscistaceInitial()) {
    on<VoiceAsscistaceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

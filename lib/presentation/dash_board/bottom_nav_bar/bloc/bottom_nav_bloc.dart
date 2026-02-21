import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(const BottomNavState(selectedIndex: 0)) {
    on<ChangeBottomNav>((event, emit) {
      emit(BottomNavState(selectedIndex: event.index));
    });
  }
}

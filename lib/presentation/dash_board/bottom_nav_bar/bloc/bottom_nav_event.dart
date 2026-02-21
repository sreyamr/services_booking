part of 'bottom_nav_bloc.dart';

abstract class BottomNavEvent extends Equatable {
  const BottomNavEvent();
  @override
  List<Object?> get props => [];
}

class ChangeBottomNav extends BottomNavEvent {
  final int index;
  const ChangeBottomNav(this.index);

  @override
  List<Object?> get props => [index];
}

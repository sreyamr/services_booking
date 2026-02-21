part of 'bottom_nav_bloc.dart';



class BottomNavState extends Equatable {
  final int selectedIndex;
  const BottomNavState({required this.selectedIndex});

  @override
  List<Object?> get props => [selectedIndex];
}

import '../home_page.dart';

abstract class HomeEvent {}

class LoadCategories extends HomeEvent {}

class SelectCategory extends HomeEvent {
  final int categoryId;
  SelectCategory(this.categoryId);
}
class LoadHome extends HomeEvent {}

class SortProviders extends HomeEvent {
  final SortType sortType;
  SortProviders(this.sortType);
}
class LoadMoreProviders extends HomeEvent {}
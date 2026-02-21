import '../../../data/models/category_model.dart';
import '../home_page.dart';

class HomeState {
  final List<CategoryModel> categories;
  final List<ProviderModel> providers;
  final int? selectedCategoryId;
  final bool loading;
  final String? userName;
  final SortType? sortType;
  final bool loadingMore;
  final bool hasMore;
  final int page;

  HomeState({
    this.categories = const [],
    this.providers = const [],
    this.selectedCategoryId,
    this.loading = false,
    this.userName,
    this.sortType,
    this.loadingMore = false,
    this.hasMore = true,
    this.page = 1,
  });

  HomeState copyWith({
    List<CategoryModel>? categories,
    List<ProviderModel>? providers,
    int? selectedCategoryId,
    bool? loading,
    String? userName,
    SortType? sortType,
    bool? loadingMore,
    bool? hasMore,
    int? page
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      providers: providers ?? this.providers,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      loading: loading ?? this.loading,
      userName: userName ?? this.userName,
      sortType: sortType ?? this.sortType,
      loadingMore: loadingMore ?? this.loadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}
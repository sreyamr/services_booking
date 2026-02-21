import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/category_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/home_repository.dart';
import '../home_page.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repo;
  final AuthRepository authRepo;

  HomeBloc(this.repo, this.authRepo) : super(HomeState()) {
    on<LoadCategories>(_onLoadCategories);
    on<SelectCategory>(_onSelectCategory);
    on<LoadHome>(_onLoadHome);
    on<SortProviders>(_onSortProviders);
    on<LoadMoreProviders>(_onLoadMoreProviders); // 👈 new
  }

  Future<void> _onLoadHome(LoadHome event, Emitter<HomeState> emit) async {
    final user = await authRepo.currentUser();
    emit(state.copyWith(userName: user?.name));
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<HomeState> emit) async {
    emit(state.copyWith(loading: true));

    final cats = await repo.categories().first;

    if (cats.isNotEmpty) {
      emit(state.copyWith(
        categories: cats,
        selectedCategoryId: cats.first.categoryId,
        loading: false,
        page: 1,
        hasMore: true,
        providers: [],
      ));

      final providers = await repo.providersByCategoryPaged(cats.first.categoryId, 1);

      emit(state.copyWith(
        providers: providers,
        hasMore: providers.isNotEmpty,
      ));
    } else {
      emit(state.copyWith(categories: [], loading: false));
    }
  }

  Future<void> _onSelectCategory(
      SelectCategory event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(
      selectedCategoryId: event.categoryId,
      loading: true,
      page: 1,
      hasMore: true,
      providers: [],
    ));

    final list = await repo.providersByCategoryPaged(event.categoryId, 1);

    emit(state.copyWith(
      providers: list,
      loading: false,
      hasMore: list.isNotEmpty,
      page: 1,
    ));
  }

  Future<void> _onLoadMoreProviders(
      LoadMoreProviders event,
      Emitter<HomeState> emit,
      ) async {
    if (state.loadingMore || !state.hasMore || state.selectedCategoryId == null) return;

    emit(state.copyWith(loadingMore: true));

    final nextPage = state.page + 1;
    final newItems = await repo.providersByCategoryPaged(
      state.selectedCategoryId!,
      nextPage,
    );

    final merged = [...state.providers, ...newItems];

    final sorted = _applySort(merged, state.sortType);

    emit(state.copyWith(
      providers: sorted,
      loadingMore: false,
      hasMore: newItems.isNotEmpty,
      page: nextPage,
    ));
  }

  Future<void> _onSortProviders(
      SortProviders event,
      Emitter<HomeState> emit,
      ) async {
    final sorted = _applySort(state.providers, event.sortType);

    emit(state.copyWith(
      providers: sorted,
      sortType: event.sortType,
    ));
  }

  List<ProviderModel> _applySort(List<ProviderModel> list, SortType? sortType) {
    final sorted = List<ProviderModel>.from(list);

    if (sortType == SortType.ratingHighToLow) {
      sorted.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (sortType == SortType.priceLowToHigh) {
      sorted.sort((a, b) => a.pricePerMinute.compareTo(b.pricePerMinute));
    }

    return sorted;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:service_booking/core/theme/app_color.dart';
import 'package:service_booking/core/theme/app_image.dart';
import 'package:service_booking/core/theme/app_text_style.dart';
import 'package:service_booking/widgets/text_fields.dart';

import '../../data/models/category_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/home_repository.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../routes/app_routes.dart';
import '../../widgets/show_confirm_dialog.dart';
import '../../widgets/sort_tile.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import 'banner_slider.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';
import 'package:carousel_slider/carousel_slider.dart';
enum SortType {
  ratingHighToLow,
  priceLowToHigh,
}


class HomePageWrapper extends StatelessWidget {
  const HomePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseAuthService = FirebaseAuthService();

    return BlocProvider(
      create: (_) => HomeBloc(
        HomeRepository(),
        AuthRepository(firebaseAuthService),
      )
        ..add(LoadHome())
        ..add(LoadCategories()),
      child: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<String> bannerImages = [
    'https://images.pexels.com/photos/6196693/pexels-photo-6196693.jpeg',
    'https://images.pexels.com/photos/5214992/pexels-photo-5214992.jpeg',
    'https://images.pexels.com/photos/7681581/pexels-photo-7681581.jpeg',
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        final homeBloc = context.read<HomeBloc>();
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
            !homeBloc.state.loadingMore) {
          homeBloc.add(LoadMoreProviders());
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        title: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final name = state.userName ?? "Guest";

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://cdn-icons-png.flaticon.com/128/11696/11696620.png"),
                      radius: 20,
                    ),
                    const SizedBox(width: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Welcome, ",
                            style: AppTextStyles.title
                                .copyWith(color: AppColors.textDark),
                          ),
                          TextSpan(
                            text: name,
                            style: AppTextStyles.title
                                .copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: AppColors.textPrimary),
                  tooltip: "Logout",
                  onPressed: () async {
                    final confirm = await showConfirmationDialog(
                      context: context,
                      title: "Logout",
                      content: "Are you sure you want to logout?",
                      confirmText: "Logout",
                      cancelText: "Cancel",
                    );
                    if (confirm != true) return;
                    context.read<AuthBloc>().add(LogoutRequested());
                    context.go(AppRoutes.login);
                  },
                ),
              ],
            );
          },
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final name = state.userName ?? "Guest";
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Banner Carousel
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: CarouselSlider(
                    items: bannerImages
                        .map(
                          (image) => ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    )
                        .toList(),
                    options: CarouselOptions(
                      height: 180,
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                  ),
                ),
              ),

              // Categories Title
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Categories", style: AppTextStyles.title),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {
                          showSortBottomSheet(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Categories List
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: state.categories.length,
                    itemBuilder: (context, i) {
                      final c = state.categories[i];
                      final isSelected = c.categoryId == state.selectedCategoryId;

                      return GestureDetector(
                        onTap: () {
                          context
                              .read<HomeBloc>()
                              .add(SelectCategory(c.categoryId));
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isSelected
                                  ? [Colors.yellow.shade200, Colors.grey.shade400]
                                  : [Colors.grey.shade200, Colors.grey.shade400],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                c.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, color: Colors.red),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                c.name,
                                style: AppTextStyles.subtitle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Providers List
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: state.providers.isEmpty
                    ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        "No data found",
                        style: AppTextStyles.subtitle.copyWith(fontSize: 16),
                      ),
                    ),
                  ),
                )
                    : SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, i) {
                      final p = state.providers[i];

                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () {
                            context.push(
                              AppRoutes.details,
                              extra: ProviderDetailArgs(provider: p, userName:name),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    p.image,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, color: Colors.red),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.name,
                                        style:
                                        AppTextStyles.poppinsSemiBold(fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.yellow.shade100,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              "⭐ ${p.rating}",
                                              style:
                                              AppTextStyles.poppinsBold(fontSize: 12),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.purple.shade100,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              "₹${p.pricePerMinute}/min",
                                              style: AppTextStyles.poppinsSemiBold(
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  p.isOnline ? "Online" : "Offline",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: p.isOnline ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: state.providers.length,
                  ),
                ),
              ),

              if (state.loadingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator(color: AppColors.primary,)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void showSortBottomSheet(BuildContext context) {
    final selected = context.read<HomeBloc>().state.sortType;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text("Sort providers", style: AppTextStyles.title),
              const SizedBox(height: 4),
              Text("Choose how you want to sort the list", style: AppTextStyles.body),
              const SizedBox(height: 20),
              SortTile(
                icon: Icons.star_rounded,
                title: "Sort by Rating",
                subtitle: "Best rated providers first",
                selected: selected == SortType.ratingHighToLow,
                onTap: () {
                  context.read<HomeBloc>().add(
                    SortProviders(SortType.ratingHighToLow),
                  );
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              SortTile(
                icon: Icons.currency_rupee_rounded,
                title: "Sort by Price",
                subtitle: "Lowest price first",
                selected: selected == SortType.priceLowToHigh,
                onTap: () {
                  context.read<HomeBloc>().add(
                    SortProviders(SortType.priceLowToHigh),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
class ProviderDetailArgs {
  final ProviderModel provider;
  final String userName;

  ProviderDetailArgs({required this.provider, required this.userName});
}
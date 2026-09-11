import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localapp/features/home/widgets/group_preview_tile.dart';

import '../../constants/postPrivetType.dart';
import '../../models/BlogList.dart';
import '../../providers/subSub Catoge.dart';
import '../home/home_provider.dart';
import 'widgets/home_appbar.dart';
import 'widgets/home_ads_slider.dart';
import 'widgets/home_blog_list.dart';
import 'widgets/home_filter_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final String CategoryId;
  final String catPrivacyType;
  final String? privacyImage;
  final String? whatsAppText;
  final String? whatsAppNumber;

  const HomeScreen(
      this.whatsAppText,
      this.whatsAppNumber,
      this.CategoryId,
      this.catPrivacyType, {
        this.privacyImage,
      });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  int selectedCategory = 0;
  int selectedSubCategory = 0;
  int? subSubCategory;

  bool hideAppbar = false;

  @override
  void initState() {
    super.initState();

    selectedCategory = int.tryParse(widget.CategoryId) ?? 0;

    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).loadHome(
        categoryId: selectedCategory,
        subCategoryId: selectedSubCategory,
        subSubCategoryId: subSubCategory ?? 0,
      );
    });
  }

  void _scrollListener() {
    if (_scrollController.offset > 0) {
      if (!hideAppbar) setState(() => hideAppbar = true);
    } else {
      if (hideAppbar) setState(() => hideAppbar = false);
    }

    final state = ref.read(homeProvider);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !state.isPaginationLoading &&
        state.blogPage < state.totalPage) {
      ref.read(homeProvider.notifier).loadMore(
        categoryId: selectedCategory,
        subCategoryId: selectedSubCategory,
        subSubCategoryId: subSubCategory ?? 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    final apiData = {
      "group_name": "Party Marathi Group",
      "initials": ["S", "K", "A"],
      "title_text": "Satish, Kishan, Avadh and 1200+ active members"
    };
    return Scaffold(
      backgroundColor: Colors.white,

      /// APP BAR
      appBar: HomeAppBar(
        hideAppbar: hideAppbar,
        categoryName: state.categories.isNotEmpty
            ? state.categories.first.CategoryName
            : '',
        onFilterTap: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => HomeFilterBar(
              subCategories: state.subCategories,
              onSelected: (id) {
                selectedSubCategory = id;
                ref.read(subSubCategoryProvider.notifier).clean();
                ref.read(homeProvider.notifier).loadHome(
                  categoryId: selectedCategory,
                  subCategoryId: selectedSubCategory,
                  subSubCategoryId: 0,
                );
              },
            ),
          );
        },
      ),

      /// BODY
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(homeProvider.notifier).loadHome(
            categoryId: selectedCategory,
            subCategoryId: selectedSubCategory,
            subSubCategoryId: subSubCategory ?? 0,
          );
        },
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          controller: _scrollController,
          children: [


            /// ADS SLIDER
            HomeAdsSlider(ads: state.ads),

            /// BLOG LIST
            HomeBlogList(
              blogs: state.blogs,
              isLoadingMore: state.isPaginationLoading,
              categoryId: selectedCategory.toString(),
              privacyType: widget.catPrivacyType,
              privacyImage: widget.privacyImage,
              whatsAppNumber: widget.whatsAppNumber,
              whatsAppText: widget.whatsAppText,
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'dart:io';

import '../../constants/Config.dart';
import '../../constants/DeviceHelper.dart';
import '../../models/BlogList.dart';
import '../../models/Category.dart';
import '../../models/SubCategory.dart';
import '../../models/LocalAd.dart';
import '../../models/City.dart';
import 'home_state.dart';

final homeProvider =
StateNotifierProvider<HomeNotifier, HomeState>(
        (ref) => HomeNotifier());

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  bool _cityLoaded = false;

  /// INITIAL LOAD
  Future<void> loadHome({
    required int categoryId,
    required int subCategoryId,
    int subSubCategoryId = 0,
  }) async {
    state = state.copyWith(isLoading: true, blogPage: 0);

    final deviceId = await DeviceHelper.getDeviceId();

    final response = await http.post(
      Uri.parse(Config.get_home),
      body: {
        'category_id': '$categoryId',
        'subcategory_id': '$subCategoryId',
        'blog_page': '0',
        'user_id': deviceId ?? '',
        'city_id': '1',
        'subsubcategory_id': '$subSubCategoryId',
      },
    );

    final data = json.decode(response.body);

    if (data['success'] == "0") {
      state = state.copyWith(
        blogs: (data['data']['blog'] as List)
            .map((e) => Blog_list.fromJson(e))
            .toList(),
        categories: (data['data']['category'] as List)
            .map((e) => Category_list.fromJson(e))
            .toList(),
        subCategories: (data['data']['sub_category'] as List)
            .map((e) => SubCategory_list.fromJson(e))
            .toList(),
        ads: (data['data']['local_ad'] as List)
            .map((e) => LocalAd_list.fromJson(e))
            .toList(),
        totalPage: data['data']['total_page'] ?? 0,
        isLoading: false,
      );

      if (!_cityLoaded) {
        await _loadCity();
      }
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  /// PAGINATION
  Future<void> loadMore({
    required int categoryId,
    required int subCategoryId,
    int subSubCategoryId = 0,
  }) async {
    if (state.isPaginationLoading ||
        state.blogPage >= state.totalPage) return;

    state = state.copyWith(
      isPaginationLoading: true,
      blogPage: state.blogPage + 1,
    );

    final deviceId = await DeviceHelper.getDeviceId();

    final response = await http.post(
      Uri.parse(Config.get_home),
      body: {
        'category_id': '$categoryId',
        'subcategory_id': '$subCategoryId',
        'blog_page': '${state.blogPage}',
        'user_id': deviceId ?? '',
        'city_id': '1',
        'subsubcategory_id': '$subSubCategoryId',
      },
    );

    final data = json.decode(response.body);

    if (data['success'] == "0") {
      final moreBlogs = (data['data']['blog'] as List)
          .map((e) => Blog_list.fromJson(e))
          .toList();

      state = state.copyWith(
        blogs: [...state.blogs, ...moreBlogs],
        isPaginationLoading: false,
      );
    } else {
      state = state.copyWith(isPaginationLoading: false);
    }
  }

  Future<void> _loadCity() async {
    final response =
    await http.post(Uri.parse(Config.get_city));
    final data = json.decode(response.body);

    if (data['success'] == "0") {
      state = state.copyWith(
        cities: (data['data'] as List)
            .map((e) => City_list.fromJson(e))
            .toList(),
      );
      _cityLoaded = true;
    }
  }
}

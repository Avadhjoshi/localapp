import '../../models/BlogList.dart';
import '../../models/Category.dart';
import '../../models/SubCategory.dart';
import '../../models/LocalAd.dart';
import '../../models/City.dart';

class HomeState {
  final bool isLoading;
  final bool isPaginationLoading;
  final int blogPage;
  final int totalPage;

  final List<Blog_list> blogs;
  final List<Category_list> categories;
  final List<SubCategory_list> subCategories;
  final List<LocalAd_list> ads;
  final List<City_list> cities;

  const HomeState({
    this.isLoading = true,
    this.isPaginationLoading = false,
    this.blogPage = 0,
    this.totalPage = 0,
    this.blogs = const [],
    this.categories = const [],
    this.subCategories = const [],
    this.ads = const [],
    this.cities = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    bool? isPaginationLoading,
    int? blogPage,
    int? totalPage,
    List<Blog_list>? blogs,
    List<Category_list>? categories,
    List<SubCategory_list>? subCategories,
    List<LocalAd_list>? ads,
    List<City_list>? cities,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isPaginationLoading:
      isPaginationLoading ?? this.isPaginationLoading,
      blogPage: blogPage ?? this.blogPage,
      totalPage: totalPage ?? this.totalPage,
      blogs: blogs ?? this.blogs,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      ads: ads ?? this.ads,
      cities: cities ?? this.cities,
    );
  }
}

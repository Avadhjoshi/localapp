import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../constants/Config.dart';
import '../../../models/LocalAd.dart';

class HomeAdsSlider extends StatelessWidget {
  final List<LocalAd_list> ads;

  const HomeAdsSlider({required this.ads});

  @override
  Widget build(BuildContext context) {
    if (ads.isEmpty) return const SizedBox();

    if (ads.length == 1) {
      return CachedNetworkImage(
        imageUrl: Config.Image_Path + 'local_ad/${ads.first.AdImage}',
        fit: BoxFit.cover,
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height / 3,
        viewportFraction: 1,
        autoPlay: true,
      ),
      items: ads.map((ad) {
        return CachedNetworkImage(
          imageUrl: Config.Image_Path + 'local_ad/${ad.AdImage}',
          fit: BoxFit.cover,
        );
      }).toList(),
    );
  }
}

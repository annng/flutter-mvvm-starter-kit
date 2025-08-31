import 'package:freezed_annotation/freezed_annotation.dart';

import '../../generated/assets.dart';

part 'home_navigation_item.freezed.dart';
part 'home_navigation_item.g.dart';

@freezed
abstract class HomeNavigationItem with _$HomeNavigationItem {
  const factory HomeNavigationItem({required String icon, String? label}) =
      _HomeNavigationItem;

  factory HomeNavigationItem.fromJson(Map<String, Object?> json) =>
      _$HomeNavigationItemFromJson(json);

  static List<HomeNavigationItem> homeItems = [
    HomeNavigationItem(icon: Assets.iconHome, label: "Beranda"),
    HomeNavigationItem(icon: Assets.iconLocation, label: "Lokasi"),
    HomeNavigationItem(icon: Assets.iconProfile, label: "Profil"),
  ];
}

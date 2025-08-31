import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm/domain/models/home_navigation_item.dart';
import 'package:flutter_mvvm/utils/res/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigationHome extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavigationHome(
      {super.key, required this.currentIndex, required this.onTap});

  final items = HomeNavigationItem.homeItems;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.grey.withAlpha(100), width: 1),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withAlpha(100),
                  blurRadius: 4,
                  spreadRadius: 4,
                  offset: Offset(0, 4))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.asMap().entries.map((entry) {
            int index = entry.key;
            HomeNavigationItem value = entry.value;
            return InkWell(
              onTap: (){
                onTap(index);
              },
                child: bottomItem(context, value, currentIndex == index));
          }).toList(),
        ),
      ),
    );
  }

  Widget bottomItem(
      BuildContext context, HomeNavigationItem item, bool isActive) {
    final Color color = isActive ? Colors.white : MyColors.grey.withAlpha(150);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color:
                isActive ? Theme.of(context).primaryColor : Colors.transparent),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            children: [
              SvgPicture.asset(
                item.icon,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              if (item.label != null) ...[
                SizedBox(
                  width: 8,
                ),
                Text(
                  item.label!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: color),
                ),
                SizedBox(
                  width: 8,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

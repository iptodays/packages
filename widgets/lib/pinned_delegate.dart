/*
 * @Author: iptoday 
 * @Date: 2022-03-31 20:58:12 
 * @Last Modified by: iptoday
 * @Last Modified time: 2022-04-23 16:11:14
 */
import 'package:flutter/material.dart';

class PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double max;
  final double min;
  final Widget Function(BuildContext context, double offset) builder;

  PinnedHeaderDelegate({
    required this.max,
    required this.min,
    required this.builder,
  }) : assert(max >= min);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return builder(context, shrinkOffset);
  }

  @override
  double get maxExtent => max;

  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant PinnedHeaderDelegate oldDelegate) =>
      max != oldDelegate.max ||
      min != oldDelegate.min ||
      builder != oldDelegate.builder;
}

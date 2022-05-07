/*
 * @Author: icedays 
 * @Date: 2020-06-03 17:53:49 
 * @Last Modified by: iptoday
 * @Last Modified time: 2022-04-22 12:49:45
 */
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ZoomHeader extends SingleChildRenderObjectWidget {
  // ignore: use_key_in_widget_constructors
  const ZoomHeader({
    required Widget child,
    required this.layoutExtent,
  }) : super(child: child);

  final double layoutExtent;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return ZoomHeaderRender(
      layoutExtent: layoutExtent,
    );
  }

  @override
  void updateRenderObject(BuildContext context, ZoomHeaderRender renderObject) {
    super.updateRenderObject(context, renderObject);

    renderObject.layoutExtent = layoutExtent;
  }
}

class ZoomHeaderRender extends RenderSliver
    with RenderObjectWithChildMixin<RenderBox>, RenderSliverHelpers {
  double layoutExtent;

  ZoomHeaderRender({
    this.layoutExtent = 0,
  }) : super();

  double lastLayoutExtent = 0;
  @override
  void performLayout() {
    if (layoutExtent != lastLayoutExtent) {
      geometry = SliverGeometry(
        scrollOffsetCorrection: layoutExtent - lastLayoutExtent,
      );
      lastLayoutExtent = layoutExtent;
      return;
    }

    final bool active = constraints.overlap < 0 || layoutExtent > 0;
    final double scrolledExted =
        constraints.overlap < 0 ? constraints.overlap.abs() : 0;

    if (active) {
      // print('-${scrolledExted} - ${constraints.scrollOffset}');
      double childSize = 0;
      if (child!.hasSize) {
        childSize = child!.size.height;
      }
      geometry = SliverGeometry(
        scrollExtent: layoutExtent,
        paintOrigin: -scrolledExted - constraints.scrollOffset,
        paintExtent: max(
          max(childSize, layoutExtent) - constraints.scrollOffset,
          0,
        ),
        maxPaintExtent: max(
          max(childSize, layoutExtent) - constraints.scrollOffset,
          0,
        ),
        layoutExtent: max(layoutExtent - constraints.scrollOffset, 0),
      );
    } else {
      geometry = SliverGeometry.zero;
    }

    child!.layout(
      constraints.asBoxConstraints(maxExtent: layoutExtent + scrolledExted),
      parentUsesSize: true,
    );
  }

  @override
  bool hitTest(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    // print('hitTest 触发');
    if (child != null) {
      return hitTestBoxChild(BoxHitTestResult.wrap(result), child!,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition);
    }
    return false;
  }

  @override
  double childMainAxisPosition(RenderBox child) {
    // print(-constraints.scrollOffset);
    return -0;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child!, offset);
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {}
}

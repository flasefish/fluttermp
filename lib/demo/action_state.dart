import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mp_chart/mp/controller/bar_chart_controller.dart';
import 'package:mp_chart/mp/controller/bubble_chart_controller.dart';
import 'package:mp_chart/mp/controller/candlestick_chart_controller.dart';
import 'package:mp_chart/mp/controller/combined_chart_controller.dart';
import 'package:mp_chart/mp/controller/horizontal_bar_chart_controller.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/controller/pie_chart_controller.dart';
import 'package:mp_chart/mp/controller/radar_chart_controller.dart';
import 'package:mp_chart/mp/controller/scatter_chart_controller.dart';
import 'package:mp_chart/mp/core/animator.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_bar_data_set.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_candle_data_set.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_data_set.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_line_data_set.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_radar_data_set.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_scatter_data_set.dart';
import 'package:mp_chart/mp/core/data_set/bar_data_set.dart';
import 'package:mp_chart/mp/core/data_set/candle_data_set.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/data_set/scatter_data_set.dart';
import 'package:mp_chart/mp/core/enums/axis_dependency.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import 'util.dart';

PopupMenuItem item(String text, String id) {
  return PopupMenuItem<String>(
      value: id,
      child: Container(
          padding: EdgeInsets.only(top: 15.0),
          child: Center(
              child: Text(
            text,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ColorUtils.BLACK,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ))));
}

abstract class ActionState<T extends StatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: <Widget>[
              PopupMenuButton<String>(
                itemBuilder: getBuilder(),
                onSelected: (String action) {
                  itemClick(action);
                },
              ),
            ],
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(getTitle())),
        body: getBody());
  }

  void itemClick(String action);

  Widget getBody();

  String getTitle();

  PopupMenuItemBuilder<String> getBuilder();

  void captureImg(CaptureCallback callback) {
  /*  PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then((permission) {
      if (permission.value != PermissionStatus.granted.value) {
        PermissionHandler()
            .requestPermissions([PermissionGroup.storage]).then((permissions) {
          if (permissions.containsKey(PermissionGroup.storage)) {
            if (permissions[PermissionGroup.storage] ==
                    PermissionStatus.granted ||
                ((permissions[PermissionGroup.storage] ==
                        PermissionStatus.unknown) &&
                    Platform.isIOS)) {
              callback();
            }
          }
        });
      } else {
        callback();
      }
    });*/
  }
}

typedef CaptureCallback = void Function();

abstract class SimpleActionState<T extends StatefulWidget>
    extends ActionState<T> {
  @override
  void itemClick(String action) {
    Util.openGithub();
  }

  @override
  getBuilder() {
    return (BuildContext context) =>
        <PopupMenuItem<String>>[
          const PopupMenuItem(child: Text('View on GitHub'),value: 'A',),
        ];
  }
}

abstract class LineActionState<T extends StatefulWidget>
    extends ActionState<T> {
  late LineChartController controller;

  @override
  getBuilder() {
    return (BuildContext context) => <PopupMenuItem<String>>[
          const PopupMenuItem(child: Text('View on GitHub'),value: 'A',),
          const PopupMenuItem(child: Text('Toggle Values'),value: 'B',),
          const PopupMenuItem(child: Text('Toggle Icons'),value: 'C',),
          const PopupMenuItem(child: Text('Toggle Filled'),value: 'D',),
          const PopupMenuItem(child: Text('Toggle Circles'),value: 'E',),
          const PopupMenuItem(child: Text('Toggle Cubic'),value: 'F',),
          const PopupMenuItem(child: Text('Toggle Stepped'),value: 'G',),
          const PopupMenuItem(child: Text('Toggle Horizontal Cubic'),value: 'H',),
          const PopupMenuItem(child: Text('Toggle PinchZoom'),value: 'I',),
          const PopupMenuItem(child: Text('Toggle Auto Scale'),value: 'J',),
          const PopupMenuItem(child: Text('Toggle Highlight'),value: 'K',),
          const PopupMenuItem(child: Text('Animate X'),value: 'L',),
          const PopupMenuItem(child: Text('Animate Y'),value: 'M',),
          const PopupMenuItem(child: Text('Animate XY'),value: 'N',),
        ];
  }

  @override
  void itemClick(String action) {
    if (controller.state == null) {
      return;
    }

    switch (action) {
      case 'A':
        Util.openGithub();
        break;
      case 'B':
        List<ILineDataSet>? sets = controller.data!.dataSets;
        for (ILineDataSet iSet in sets!) {
          LineDataSet set = iSet as LineDataSet;
          set.setDrawValues(!set.isDrawValuesEnabled());
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'C':
        List<ILineDataSet>? sets = controller.data!.dataSets;
        for (ILineDataSet iSet in sets!) {
          LineDataSet set = iSet as LineDataSet;
          set.setDrawIcons(!set.isDrawIconsEnabled());
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'D':
        List<ILineDataSet>? sets = controller.data!.dataSets;

        for (ILineDataSet iSet in sets!) {
          LineDataSet set = iSet as LineDataSet;
          if (set.isDrawFilledEnabled())
            set.setDrawFilled(false);
          else
            set.setDrawFilled(true);
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'E':
        List<ILineDataSet>? sets = controller.data!.dataSets;

        for (ILineDataSet iSet in sets!) {
          LineDataSet set = iSet as LineDataSet;
          if (set.isDrawCirclesEnabled())
            set.setDrawCircles(false);
          else
            set.setDrawCircles(true);
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'F':
        List<ILineDataSet>? sets = controller.data!.dataSets;

        for (ILineDataSet iSet in sets!) {
          LineDataSet set = iSet as LineDataSet;
          set.setMode(set.getMode() == Mode.CUBIC_BEZIER
              ? Mode.LINEAR
              : Mode.CUBIC_BEZIER);
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'G':
        List<ILineDataSet>? sets = controller.data!.dataSets;

        for (ILineDataSet iSet in sets!) {
          LineDataSet set = iSet as LineDataSet;
          set.setMode(
              set.getMode() == Mode.STEPPED ? Mode.LINEAR : Mode.STEPPED);
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'H':
        List<ILineDataSet>? sets = controller.data!.dataSets;

        for (ILineDataSet iSet in sets!) {
          LineDataSet set = iSet as LineDataSet;
          set.setMode(set.getMode() == Mode.HORIZONTAL_BEZIER
              ? Mode.LINEAR
              : Mode.HORIZONTAL_BEZIER);
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'I':
        controller.pinchZoomEnabled = !controller.pinchZoomEnabled;
        controller.state!.setStateIfNotDispose();
        break;
      case 'J':
        controller.autoScaleMinMaxEnabled = !controller.autoScaleMinMaxEnabled;
        controller.state!.setStateIfNotDispose();
        break;
      case 'K':
        if (controller.data != null) {
          controller.data!
              .setHighlightEnabled(!controller.data!.isHighlightEnabled());
          controller.state!.setStateIfNotDispose();
        }
        break;
      case 'L':
        controller.animator!
          ..reset()
          ..animateX1(2000);
        break;
      case 'M':
        controller.animator!
          ..reset()
          ..animateY2(2000, Easing.EaseInCubic);
        break;
      case 'N':
        controller.animator!
          ..reset()
          ..animateXY1(2000, 2000);
        break;
    }
  }
}

abstract class BarActionState<T extends StatefulWidget> extends ActionState<T> {
  late BarChartController controller;

  @override
  getBuilder() {
    return (BuildContext context) => <PopupMenuItem<String>>[
      const PopupMenuItem(child: Text('View on GitHub'),value: 'A',),
      const PopupMenuItem(child: Text('Toggle Bar Borders'),value: 'B',),
      const PopupMenuItem(child: Text('Toggle Values'),value: 'C',),
      const PopupMenuItem(child: Text('Toggle Icons'),value: 'D',),
      const PopupMenuItem(child: Text('Toggle Highlight'),value: 'E',),
      const PopupMenuItem(child: Text('Toggle PinchZoom'),value: 'F',),
      const PopupMenuItem(child: Text('Toggle Auto Scale'),value: 'G',),
      const PopupMenuItem(child: Text('Animate X'),value: 'H',),
      const PopupMenuItem(child: Text('Animate Y'),value: 'I',),
      const PopupMenuItem(child: Text('Animate XY'),value: 'J',),
        ];
  }

  @override
  void itemClick(String action) {
    if (controller.state == null) {
      return;
    }

    switch (action) {
      case 'A':
        Util.openGithub();
        break;
      case 'B':
        for (IBarDataSet set in controller.data!.dataSets!)
          (set as BarDataSet)
              .setBarBorderWidth(set.getBarBorderWidth() == 1.0 ? 0.0 : 1.0);
        controller.state!.setStateIfNotDispose();
        break;
      case 'C':
        for (IDataSet set in controller.data!.dataSets!)
          set.setDrawValues(!set.isDrawValuesEnabled());
        controller.state!.setStateIfNotDispose();
        break;
      case 'D':
        List<IBarDataSet> sets = controller.data!.dataSets!;
        for (IBarDataSet iSet in sets) {
          BarDataSet set = iSet as BarDataSet;
          set.setDrawIcons(!set.isDrawIconsEnabled());
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'E':
        if (controller.data != null) {
          controller.data!
              .setHighlightEnabled(!controller.data!.isHighlightEnabled());
          controller.state!.setStateIfNotDispose();
        }
        break;
      case 'F':
        controller.pinchZoomEnabled = !controller.pinchZoomEnabled;
        controller.state!.setStateIfNotDispose();
        break;
      case 'G':
        controller.autoScaleMinMaxEnabled = !controller.autoScaleMinMaxEnabled;
        controller.state!.setStateIfNotDispose();
        break;
      case 'H':
        controller.animator!
          ..reset()
          ..animateX1(2000);
        break;
      case 'I':
        controller.animator!
          ..reset()
          ..animateY1(2000);
        break;
      case 'J':
        controller.animator!
          ..reset()
          ..animateXY1(2000, 2000);
        break;
    }
  }
}

abstract class HorizontalBarActionState<T extends StatefulWidget>
    extends ActionState<T> {
  late HorizontalBarChartController controller;

  @override
  getBuilder() {
    return (BuildContext context) => <PopupMenuItem<String>>[
      const PopupMenuItem(child: Text('View on GitHub'),value: 'A',),
      const PopupMenuItem(child: Text('Toggle Bar Borders'),value: 'B',),
      const PopupMenuItem(child: Text('Toggle Values'),value: 'C',),
      const PopupMenuItem(child: Text('Toggle Icons'),value: 'D',),
      const PopupMenuItem(child: Text('Toggle Highlight'),value: 'E',),
      const PopupMenuItem(child: Text('Toggle PinchZoom'),value: 'F',),
      const PopupMenuItem(child: Text('Toggle Auto Scale'),value: 'G',),
      const PopupMenuItem(child: Text('Animate X'),value: 'H',),
      const PopupMenuItem(child: Text('Animate Y'),value: 'I',),
      const PopupMenuItem(child: Text('Animate XY'),value: 'J',),
        ];
  }

  @override
  void itemClick(String action) {
    if (controller.state == null) {
      return;
    }

    switch (action) {
      case 'A':
        Util.openGithub();
        break;
      case 'B':
        for (IBarDataSet set in controller.data!.dataSets!)
          (set as BarDataSet)
              .setBarBorderWidth(set.getBarBorderWidth() == 1.0 ? 0.0 : 1.0);
        controller.state!.setStateIfNotDispose();
        break;
      case 'C':
        for (IDataSet set in controller.data!.dataSets!)
          set.setDrawValues(!set.isDrawValuesEnabled());
        controller.state!.setStateIfNotDispose();
        break;
      case 'D':
        List<IBarDataSet> sets = controller.data!.dataSets!;
        for (IBarDataSet iSet in sets) {
          BarDataSet set = iSet as BarDataSet;
          set.setDrawIcons(!set.isDrawIconsEnabled());
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'E':
        if (controller.data != null) {
          controller.data!
              .setHighlightEnabled(!controller.data!.isHighlightEnabled());
          controller.state!.setStateIfNotDispose();
        }
        break;
      case 'F':
        controller.pinchZoomEnabled = !controller.pinchZoomEnabled;
        controller.state!.setStateIfNotDispose();
        break;
      case 'G':
        controller.autoScaleMinMaxEnabled = !controller.autoScaleMinMaxEnabled;
        controller.state!.setStateIfNotDispose();
        break;
      case 'H':
        controller.animator!
          ..reset()
          ..animateX1(2000);
        break;
      case 'I':
        controller.animator!
          ..reset()
          ..animateY1(2000);
        break;
      case 'J':
        controller.animator!
          ..reset()
          ..animateXY1(2000, 2000);
        break;
    }
  }
}

abstract class PieActionState<T extends StatefulWidget> extends ActionState<T> {
  late PieChartController controller;

  @override
  getBuilder() {
    return (BuildContext context) => <PopupMenuItem<String>>[
      const PopupMenuItem(child: Text('View on GitHub'),value: 'A',),
      const PopupMenuItem(child: Text('Toggle Y-Values'),value: 'B',),
      const PopupMenuItem(child: Text('Toggle X-Values'),value: 'C',),
      const PopupMenuItem(child: Text('Toggle Icons'),value: 'D',),
      const PopupMenuItem(child: Text('Toggle Percent'),value: 'E',),
      const PopupMenuItem(child: Text('Toggle Minimum Angles'),value: 'F',),
      const PopupMenuItem(child: Text('Toggle Hole'),value: 'G',),
      const PopupMenuItem(child: Text('Toggle Curved Slices Cubic'),value: 'H',),
      const PopupMenuItem(child: Text('Draw Center Text'),value: 'I',),
      const PopupMenuItem(child: Text('Spin Animation'),value: 'J',),
      const PopupMenuItem(child: Text('Animate X'),value: 'K',),
      const PopupMenuItem(child: Text('Animate Y'),value: 'L',),
      const PopupMenuItem(child: Text('Animate XY'),value: 'M',),
        ];
  }

  @override
  void itemClick(String action) {
    if (controller.state == null) {
      return;
    }

    switch (action) {
      case 'A':
        Util.openGithub();
        break;
      case 'B':
        for (IDataSet set in controller.data!.dataSets!)
          set.setDrawValues(!set.isDrawValuesEnabled());
        controller.state!.setStateIfNotDispose();
        break;
      case 'C':
        controller.drawEntryLabels = !controller.drawEntryLabels;
        controller.state!.setStateIfNotDispose();
        break;
      case 'D':
        for (IDataSet set in controller.data!.dataSets!)
          set.setDrawIcons(!set.isDrawIconsEnabled());
        controller.state!.setStateIfNotDispose();
        break;
      case 'E':
        controller.usePercentValues = !controller.usePercentValues;
        controller.state!.setStateIfNotDispose();
        break;
      case 'F':
        if (controller.minAngleForSlices == 0) {
          controller.minAngleForSlices = 36;
        } else {
          controller.minAngleForSlices = 0;
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'G':
        controller.drawHole = !controller.drawHole;
        controller.state!.setStateIfNotDispose();
        break;
      case 'H':
        bool toSet = !controller.drawRoundedSlices || !controller.drawHole;
        controller.drawRoundedSlices = toSet;
        if (toSet && !controller.drawHole) {
          controller.drawHole = true;
        }
        if (toSet && controller.drawSlicesUnderHole) {
          controller.drawSlicesUnderHole = false;
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'I':
        controller.drawCenterText = !controller.drawCenterText;
        controller.state!.setStateIfNotDispose();
        break;
      case 'J':
        controller.animator!
          ..reset()
          ..spin(2000, controller.rotationAngle, controller.rotationAngle + 360,
              Easing.EaseInOutCubic);
        break;
      case 'K':
        controller.animator!
          ..reset()
          ..animateX1(1400);
        break;
      case 'L':
        controller.animator!
          ..reset()
          ..animateY1(1400);
        break;
      case 'M':
        controller.animator!
          ..reset()
          ..animateXY1(1400, 1400);
        break;
    }
  }
}

abstract class CombinedActionState<T extends StatefulWidget>
    extends ActionState<T> {
  late CombinedChartController controller;

  @override
  getBuilder() {
    return (BuildContext context) => <PopupMenuItem<String>>[
      const PopupMenuItem(child: Text('View on GitHub'),value: 'A',),
      const PopupMenuItem(child: Text('Toggle Line Values'),value: 'B',),
      const PopupMenuItem(child: Text('Toggle Bar Values'),value: 'C',),
      const PopupMenuItem(child: Text('Remove Data Set'),value: 'D',),
      const PopupMenuItem(child: Text('Set Y Range Test'),value: 'E',),
        ];
  }

  @override
  void itemClick(String action) {
    if (controller.state == null) {
      return;
    }

    switch (action) {
      case 'A':
        Util.openGithub();
        break;
      case 'B':
        for (IDataSet set in controller.data!.dataSets!) {
          if (set is LineDataSet) set.setDrawValues(!set.isDrawValuesEnabled());
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'C':
        for (IDataSet set in controller.data!.dataSets!) {
          if (set is BarDataSet) set.setDrawValues(!set.isDrawValuesEnabled());
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'D':
        if (controller.data!.getDataSetCount() > 1) {
          int rnd = _getRandom(controller.data!.getDataSetCount().toDouble(), 0)
              .toInt();
          controller.data!
              .removeDataSet1(controller.data!.getDataSetByIndex(rnd)!);
          controller.data!.notifyDataChanged();
          controller.state!.setStateIfNotDispose();
        }
        break;
      case 'E':
        controller.setVisibleYRangeMaximum(100, AxisDependency.LEFT);
        controller.state!.setStateIfNotDispose();
        break;
    }
  }

  double _getRandom(double range, double start) {
    return (Random(1).nextDouble() * range) + start;
  }
}

abstract class ScatterActionState<T extends StatefulWidget>
    extends ActionState<T> {
  late ScatterChartController controller;

  @override
  getBuilder() {
    return (BuildContext context) => <PopupMenuItem<String>>[
      const PopupMenuItem(child: Text('View on GitHub'),value: 'A',),
      const PopupMenuItem(child: Text('Toggle Values'),value: 'B',),
      const PopupMenuItem(child: Text('Toggle Icons'),value: 'C',),
      const PopupMenuItem(child: Text('Toggle Highlight'),value: 'D',),
      const PopupMenuItem(child: Text('Animate X'),value: 'E',),
      const PopupMenuItem(child: Text('Animate Y'),value: 'F',),
      const PopupMenuItem(child: Text('Animate XY'),value: 'G',),
      const PopupMenuItem(child: Text('Toggle PinchZoom'),value: 'H',),
      const PopupMenuItem(child: Text('Toggle Auto Scale'),value: 'I',),
        ];
  }

  @override
  void itemClick(String action) {
    if (controller.state == null) {
      return;
    }

    switch (action) {
      case 'A':
        Util.openGithub();
        break;
      case 'B':
        List<IScatterDataSet>? sets = controller.data!.dataSets;
        for (IScatterDataSet iSet in sets!) {
          ScatterDataSet set = iSet as ScatterDataSet;
          set.setDrawValues(!set.isDrawValuesEnabled());
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'C':
        for (IDataSet set in controller.data!.dataSets!)
          set.setDrawIcons(!set.isDrawIconsEnabled());
        controller.state!.setStateIfNotDispose();
        break;
      case 'D':
        if (controller.data != null) {
          controller.data!
              .setHighlightEnabled(!controller.data!.isHighlightEnabled());
          controller.state!.setStateIfNotDispose();
        }
        break;
      case 'E':
        controller.animator!
          ..reset()
          ..animateX1(3000);
        break;
      case 'F':
        controller.animator!
          ..reset()
          ..animateY1(3000);
        break;
      case 'G':
        controller.animator!
          ..reset()
          ..animateXY1(3000, 3000);
        break;
      case 'H':
        controller.pinchZoomEnabled = !controller.pinchZoomEnabled;
        controller.state!.setStateIfNotDispose();
        break;
      case 'I':
        controller.autoScaleMinMaxEnabled = !controller.autoScaleMinMaxEnabled;
        controller.state!.setStateIfNotDispose();
        break;
    }
  }
}

abstract class BubbleActionState<T extends StatefulWidget>
    extends ActionState<T> {
  late BubbleChartController controller;

  @override
  getBuilder() {
    return (BuildContext context) => <PopupMenuItem<String>>[
      const PopupMenuItem(child: Text('View on GitHub'),value: 'A',),
      const PopupMenuItem(child: Text('Toggle Values'),value: 'B',),
      const PopupMenuItem(child: Text('Toggle Icons'),value: 'C',),
      const PopupMenuItem(child: Text('Toggle Highlight'),value: 'D',),
      const PopupMenuItem(child: Text('Toggle PinchZoom'),value: 'H',),
      const PopupMenuItem(child: Text('Toggle Auto Scale'),value: 'I',),
      const PopupMenuItem(child: Text('Animate X'),value: 'E',),
      const PopupMenuItem(child: Text('Animate Y'),value: 'F',),
      const PopupMenuItem(child: Text('Animate XY'),value: 'G',),
        ];
  }

  @override
  void itemClick(String action) {
    if (controller.state == null) {
      return;
    }

    switch (action) {
      case 'A':
        Util.openGithub();
        break;
      case 'B':
        for (IDataSet set in controller.data!.dataSets!)
          set.setDrawValues(!set.isDrawValuesEnabled());
        controller.state!.setStateIfNotDispose();
        break;
      case 'C':
        for (IDataSet set in controller.data!.dataSets!)
          set.setDrawIcons(!set.isDrawIconsEnabled());
        controller.state!.setStateIfNotDispose();
        break;
      case 'D':
        if (controller.data != null) {
          controller.data!
              .setHighlightEnabled(!controller.data!.isHighlightEnabled());
          controller.state!.setStateIfNotDispose();
        }
        break;
      case 'E':
        controller.animator!
          ..reset()
          ..animateX1(2000);
        break;
      case 'F':
        controller.animator!
          ..reset()
          ..animateY1(2000);
        break;
      case 'G':
        controller.animator!
          ..reset()
          ..animateXY1(2000, 2000);
        break;
      case 'H':
        controller.pinchZoomEnabled = !controller.pinchZoomEnabled;
        controller.state!.setStateIfNotDispose();
        break;
      case 'I':
        controller.autoScaleMinMaxEnabled = !controller.autoScaleMinMaxEnabled;
        controller.state!.setStateIfNotDispose();
        break;
    }
  }
}

abstract class CandlestickActionState<T extends StatefulWidget>
    extends ActionState<T> {
  late CandlestickChartController controller;

  @override
  getBuilder() {
    return (BuildContext context) => <PopupMenuItem<String>>[
      const PopupMenuItem(child: Text('View on GitHub'),value: 'A',),
      const PopupMenuItem(child: Text('Toggle Values'),value: 'B',),
      const PopupMenuItem(child: Text('Toggle Icons'),value: 'C',),
      const PopupMenuItem(child: Text('Toggle Highlight'),value: 'D',),
      const PopupMenuItem(child: Text('Toggle Shadow Color'),value: 'K',),
      const PopupMenuItem(child: Text('Toggle PinchZoom'),value: 'H',),
      const PopupMenuItem(child: Text('Toggle Auto Scale'),value: 'I',),
      const PopupMenuItem(child: Text('Animate X'),value: 'E',),
      const PopupMenuItem(child: Text('Animate Y'),value: 'F',),
      const PopupMenuItem(child: Text('Animate XY'),value: 'G',),
    ];
  }

  @override
  void itemClick(String action) {
    if (controller.state == null) {
      return;
    }

    switch (action) {
      case 'A':
        Util.openGithub();
        break;
      case 'B':
        for (IDataSet set in controller.data!.dataSets!)
          set.setDrawValues(!set.isDrawValuesEnabled());
        controller.state!.setStateIfNotDispose();
        break;
      case 'C':
        for (IDataSet set in controller.data!.dataSets!)
          set.setDrawIcons(!set.isDrawIconsEnabled());
        controller.state!.setStateIfNotDispose();
        break;
      case 'D':
        if (controller.data != null) {
          controller.data!
              .setHighlightEnabled(!controller.data!.isHighlightEnabled());
          controller.state!.setStateIfNotDispose();
        }
        break;
      case 'E':
        controller.animator!
          ..reset()
          ..animateX1(2000);
        break;
      case 'F':
        controller.animator!
          ..reset()
          ..animateY1(2000);
        break;
      case 'G':
        controller.animator!
          ..reset()
          ..animateXY1(2000, 2000);
        break;
      case 'H':
        controller.pinchZoomEnabled = !controller.pinchZoomEnabled;
        controller.state!.setStateIfNotDispose();
        break;
      case 'I':
        controller.autoScaleMinMaxEnabled = !controller.autoScaleMinMaxEnabled;
        controller.state!.setStateIfNotDispose();
        break;
      case 'J':
        for (ICandleDataSet set in controller.data!.dataSets!) {
          (set as CandleDataSet)
              .setShadowColorSameAsCandle(!set.getShadowColorSameAsCandle());
        }
        controller.state!.setStateIfNotDispose();
        break;
    }
  }
}

abstract class RadarActionState<T extends StatefulWidget>
    extends ActionState<T> {
  late RadarChartController controller;

  @override
  getBuilder() {
    return (BuildContext context) => <PopupMenuItem<String>>[
      const PopupMenuItem(child: Text('View on GitHub'),value: 'A',),
      const PopupMenuItem(child: Text('Toggle Values'),value: 'B',),
      const PopupMenuItem(child: Text('Toggle Icons'),value: 'C',),
      const PopupMenuItem(child: Text('Toggle Filled'),value: 'D',),
      const PopupMenuItem(child: Text('Toggle Highlight'),value: 'E',),
      const PopupMenuItem(child: Text('Toggle Highlight Circle'),value: 'F',),
      const PopupMenuItem(child: Text('Toggle Rotation'),value: 'G',),
      const PopupMenuItem(child: Text('Toggle Y-Values'),value: 'H',),
      const PopupMenuItem(child: Text('Toggle X-Values'),value: 'I',),
      const PopupMenuItem(child: Text('Spin Animation'),value: 'J',),
      const PopupMenuItem(child: Text('Animate X'),value: 'K',),
      const PopupMenuItem(child: Text('Animate Y'),value: 'L',),
      const PopupMenuItem(child: Text('Animate XY'),value: 'M',),
        ];
  }

  @override
  void itemClick(String action) {
    if (controller.state == null) {
      return;
    }

    switch (action) {
      case 'A':
        Util.openGithub();
        break;
      case 'B':
        for (IDataSet set in controller.data!.dataSets!)
          set.setDrawValues(!set.isDrawValuesEnabled());
        controller.state!.setStateIfNotDispose();
        break;
      case 'C':
        for (IDataSet set in controller.data!.dataSets!)
          set.setDrawIcons(!set.isDrawIconsEnabled());
        controller.state!.setStateIfNotDispose();
        break;
      case 'D':
        List<IRadarDataSet>? sets = controller.data!.dataSets;
        for (IRadarDataSet set in sets!) {
          if (set.isDrawFilledEnabled())
            set.setDrawFilled(false);
          else
            set.setDrawFilled(true);
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'E':
        if (controller.data != null) {
          controller.data!
              .setHighlightEnabled(!controller.data!.isHighlightEnabled());
          controller.state!.setStateIfNotDispose();
        }
        break;
      case 'F':
        List<IRadarDataSet>? sets = controller.data!.dataSets;
        for (IRadarDataSet set in sets!) {
          set.setDrawHighlightCircleEnabled(
              !set.isDrawHighlightCircleEnabled());
        }
        controller.state!.setStateIfNotDispose();
        break;
      case 'G':
        controller.rotateEnabled = controller.rotateEnabled;
        controller.state!.setStateIfNotDispose();
        break;
      case 'H':
        controller.yAxis!.enabled = controller.yAxis!.enabled;
        controller.state!.setStateIfNotDispose();
        break;
      case 'I':
        controller.xAxis!.enabled = controller.xAxis!.enabled;
        controller.state!.setStateIfNotDispose();
        break;
      case 'J':
        controller.animator!
          ..reset()
          ..spin(2000, controller.rotationAngle, controller.rotationAngle + 360,
              Easing.EaseInOutCubic);
        break;
      case 'K':
        controller.animator!
          ..reset()
          ..animateX1(1400);
        break;
      case 'L':
        controller.animator!
          ..reset()
          ..animateY1(1400);
        break;
      case 'M':
        controller.animator!
          ..reset()
          ..animateXY1(1400, 1400);
        break;
    }
  }
}

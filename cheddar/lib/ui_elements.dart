import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyPieChart extends StatefulWidget {
  const MyPieChart({
    super.key,

    required this.innerNameData,
    required this.innerData,
    required this.innerName,
    required this.innerIconData,

    required this.outerNameData,
    required this.outerData,
    required this.outerName,
    required this.outerIconData,

    required this.radius,
  });

  final double radius;

  final int dec = 2; //how many decimal places values have

  final List<double> innerData;
  final List<double> outerData;

  final List<String> outerNameData;
  final List<String> innerNameData;

  final List<Icon> outerIconData;
  final List<Icon> innerIconData;

  final String outerName;
  final String innerName;

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  int touchedIndex = -1;
  bool inRadius =
      false; //whether or not the touch event is inside the inner radius
  bool outRadius =
      true; //whether or not the touch event is outside the outer radius
  bool toggleOn = false;
  int prevTouchIndex = -1;

  double outerSum = -1;
  double innerSum = -1;

  //prebuild sections for dynamic editing
  List<PieChartSectionData> innerSections = [];
  List<PieChartSectionData> outerSections = [];

  bool innerFiller = false; //is there an inner filler section
  bool outerFiller = false; //is there an outer filler section

  

  void _addFillerSection( bool isInner, double val){
    setState(() {
      if (isInner == true){ //add to inner //overbudget
          widget.innerData.add(val);
          widget.innerNameData.add('Over Spent');
          widget.innerIconData.add(Icon(Icons.cancel));
          innerFiller = true;
          
      } else {// add to outer //underbudget
          widget.outerData.add(val);
          widget.outerNameData.add('Saved');
          widget.outerIconData.add(Icon(Icons.check));
          outerFiller = true;
      }
    });
  }

  void _handlePieTouch(FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
    setState(() {
      if (!event.isInterestedForInteractions ||
          pieTouchResponse == null ||
          pieTouchResponse.touchedSection == null) {
        touchedIndex = -1;

        return;
      }
      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;

      final renderBox = context.findRenderObject();
      if (renderBox is! RenderBox) {
        return;
      }
      final center = renderBox.size.center(Offset.zero);
      final touchPosition = event.localPosition;
      if (touchPosition != null) {
        final dx = touchPosition.dx - center.dx;
        final dy = touchPosition.dy - center.dy;
        final distanceFromCenter = sqrt((dx * dx) + (dy * dy));

        inRadius = distanceFromCenter < 9.9 * widget.radius;
        outRadius = distanceFromCenter > 15 * widget.radius;
      }
    });
  }

  Widget _innerPieChart() {
    //premake sections:
    innerSections = [
      for (int i = 0; i < widget.innerData.length; i++)
        PieChartSectionData(
          showTitle: false,
          badgeWidget: widget.innerIconData[i],
          value: widget.innerData[i],
          color: Colors.green[(i + 5) * 100],
          radius: (outRadius)
            ? widget.radius * 4
            : (inRadius && !toggleOn)
            ? widget.radius * 4 * 1.2
            : widget.radius *
            4 *
            ((prevTouchIndex == i && inRadius && toggleOn)
            ? 1.4
            : 1.0),
          ),
        ];

    innerSum = widget.innerData.fold(
      0,
      (previousValue, element) => previousValue + element,
    );
    if (innerFiller == true){
      innerSum -= widget.innerData.last;
    }
    return IgnorePointer(
      ignoring: !inRadius,
      child: PieChart(
        swapAnimationDuration: const Duration(milliseconds: 200),
        swapAnimationCurve: Curves.easeInOut,

        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (event, pieTouchResponse) {
              _handlePieTouch(event, pieTouchResponse);
            },
          ),
          centerSpaceRadius: 6 * widget.radius,
          sectionsSpace: 0,
          sections: innerSections
        ),
      ),
    );
  }

  Widget _outerPieChart() {
    //premake sections:
    outerSections = [
    for (int i = 0; i < widget.outerData.length; i++)
      PieChartSectionData(
        showTitle: false,
        badgeWidget: widget.outerIconData[i],
        value: widget.outerData[i],
        color: Colors.red[(i + 5) * 100],
        radius: (outRadius)
          ? widget.radius * 4
          : (!inRadius && !toggleOn)
          ? widget.radius * 4 * 1.2
          : widget.radius *
          4 *
          ((prevTouchIndex == i && !inRadius && toggleOn)
          ? 1.4
          : 1.0),
            ),
        ];

    outerSum = widget.outerData.fold(
      0,
      (previousValue, element) => previousValue + element,
    );

    if (outerFiller == true){
      outerSum -= widget.outerData.last;
    }
    return PieChart(
      swapAnimationDuration: const Duration(milliseconds: 200),
      swapAnimationCurve: Curves.easeInOut,
      PieChartData(
        pieTouchData: PieTouchData(
          enabled: true,
          touchCallback: (event, pieTouchResponse) {
            _handlePieTouch(event, pieTouchResponse);
          },
        ),
        centerSpaceRadius: 9.9 * widget.radius,
        sectionsSpace: 0,

        sections: outerSections
      ),
    );
  }

  Widget _centerText() {
    final String chartName = inRadius ? widget.innerName : widget.outerName;

    final String summary = (innerSum == outerSum)
        ? 'On Budget'
        : (innerSum > outerSum)
        ? 'Under Budget'
        : 'Over Budget';

    String centerTitle = outRadius ? summary : chartName;

    String centerSubtitle = (innerSum == outerSum && outRadius)
        ? ''
        : outRadius
        ? '\$${(innerSum - outerSum).abs().toStringAsFixed(widget.dec)}'
        : (inRadius)
        ? '\$${innerSum.toStringAsFixed(widget.dec)}'
        : '\$${outerSum.toStringAsFixed(widget.dec)}';

    if (toggleOn == true && prevTouchIndex != -1) {
      final String sliceName = inRadius
          ? widget.innerNameData[prevTouchIndex]
          : widget.outerNameData[prevTouchIndex];

      final String sliceAmount = inRadius
          ? widget.innerData[prevTouchIndex].toStringAsFixed(widget.dec)
          : widget.outerData[prevTouchIndex].toStringAsFixed(widget.dec);
      centerTitle = sliceName;
      centerSubtitle = ' \$$sliceAmount';
    }
    setState(() {
      if (touchedIndex != -1) {
        if (prevTouchIndex == touchedIndex) {
          prevTouchIndex = -1;
          toggleOn = false;
        } else {
          prevTouchIndex = touchedIndex;
          toggleOn = true;
        }
        ;
      } else {
        toggleOn = false;
      }

    
    //auto filler sections
      print(innerFiller);
      print(outerFiller);
      
      if (innerSum != outerSum && innerFiller == false && outerFiller == false){
        print('here');
        double diff = (innerSum-outerSum).abs();
        if (innerSum > outerSum){ //under budget
          _addFillerSection(false, diff);
        } else {// over budget
          _addFillerSection(true, diff);
          
        }
      }
    
    });
    
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          //chart title or Slice Title
          centerTitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 2 * widget.radius,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          //$ amount or nothing
          centerSubtitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 2 * widget.radius,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [_outerPieChart(), _innerPieChart(), _centerText()],
    );
  }
}

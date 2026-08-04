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
  bool oneTouch = true;

  double outerSum = -1;
  double innerSum = -1;
  double diff = -1;

  int innerLength = -1;
  int outerLength = -1;//lengths set before adding filler

  //prebuild sections for dynamic editing
  List<PieChartSectionData> innerSections = [];
  List<PieChartSectionData> outerSections = [];

  bool innerFiller = false; //is there an inner filler section
  bool outerFiller = false; //is there an outer filler section

  void _addFillerSection( bool isInner, double val){
    setState(() {
      if (isInner == true){ //add to inner //overbudget
        innerSections.add(
          PieChartSectionData(
          showTitle: false,
          value: val,
          color: const Color.fromARGB(70, 255, 18, 1),
          radius: widget.radius * 4 *(
            (prevTouchIndex == innerLength)
            ? 0.8
            : 0.5
          ),
          ),
        );
        widget.innerNameData.add('Over Spent');
        widget.innerData.add(val);
          
      } else {// add to outer //underbudget
        outerSections.add(
          PieChartSectionData(
          showTitle: false,
          value: val,
          color: const Color.fromARGB(160, 157, 255, 132),
          radius: widget.radius * 4 *(
            (prevTouchIndex == outerLength)
            ? 0.8
            : 0.5
          )
          ),
        );
          widget.outerNameData.add('Saved');
          widget.outerData.add(val);
      }
    });
  }
  @override
  void initState(){
    super.initState();
    innerSum = widget.innerData.fold(0, (previousValue, element) => previousValue + element);
    outerSum = widget.outerData.fold(0, (previousValue, element) => previousValue + element);

    innerLength = widget.innerData.length;

    outerLength = widget.outerData.length;

     if (innerSum != outerSum ){
        diff = (innerSum-outerSum).abs();
     }
  }

  void _handlePieTouch(FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
    setState(() {
      if (!event.isInterestedForInteractions ||
          pieTouchResponse == null ||
          pieTouchResponse.touchedSection == null) {
        touchedIndex = -1;
        oneTouch = true;        
        return;
      }
      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
  
      if (oneTouch == true){
        oneTouch = false;
        if (prevTouchIndex == touchedIndex) {
            prevTouchIndex = -1;
            toggleOn = false;
            return;
          } else {
            prevTouchIndex = touchedIndex;
            toggleOn = true;
            return;
          }
      }

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
    for (int i = 0; i < innerLength ; i++) 
      PieChartSectionData(
          showTitle: false,
          badgeWidget: widget.innerIconData[i],
          value: widget.innerData[i],
          color: Colors.yellow[(i + 6) * 100],
          radius: widget.radius * 4 *(
            (!inRadius)
            ? 1
            : (!toggleOn)
            ? 1.2
            :(prevTouchIndex == i)
            ? 1.4
            : 1
            ),
          ),
        ];
    if (diff != -1 && innerSum < outerSum){
      _addFillerSection(true,diff);
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
    for (int i = 0; i < outerLength; i++)
      PieChartSectionData(
        showTitle: false,
        badgeWidget: widget.outerIconData[i],
        value: widget.outerData[i],
        color: Colors.orange[(i + 8) * 100],
        radius: widget.radius * 4 *(
            (outRadius)
            ? 1
            :(inRadius)
            ?1
            : (!toggleOn)
            ? 1.2
            :(prevTouchIndex == i)
            ? 1.4
            : 1
            )
          ),
        ];
    if (diff != -1 && innerSum > outerSum){
      _addFillerSection(false,diff);
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
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          //chart title or Slice Title
          centerTitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 1.5*widget.radius,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          //$ amount or nothing
          centerSubtitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: widget.radius,
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

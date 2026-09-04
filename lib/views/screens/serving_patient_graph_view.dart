import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/models/response/doctor/bp_graph_response.dart';
import 'package:digi_icu_flutter/models/response/doctor/other_graph_response.dart';
import 'package:digi_icu_flutter/models/response/doctor/sugar_graph_response.dart';
import 'package:digi_icu_flutter/views/widgets/app_form_section_header.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/graph_legend_badge.dart';
import 'package:digi_icu_flutter/views/widgets/lab_parameter_table_row.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ServingPatientGraphView extends GetView<ServingPatientController> {
  const ServingPatientGraphView({super.key});

  String _formatDate(String rawDate) {
    if (rawDate.isEmpty) return '-';
    try {
      final parsed = DateTime.parse(rawDate);
      return DateFormat('dd-MM-yy').format(parsed);
    } catch (_) {
      return rawDate;
    }
  }

  double _parseDouble(String? val) {
    if (val == null || val.isEmpty) return 0.0;
    return double.tryParse(val) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingGraph.value) {
        return const Center(child: AppLoadingOverlay(isLoading: true));
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchGraphData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. BP GRAPH SECTION
              // ==========================================
              AppFormSectionHeader(title: 'bp_graph_title'.tr),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GraphLegendBadge(color: AppColors.teal, label: 'target_bp'.tr),
                  GraphLegendBadge(color: AppColors.warning, label: 'systolic'.tr),
                  GraphLegendBadge(color: AppColors.blue, label: 'diastolic'.tr),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: _buildBPLineChart(context, controller.bpGraphList, controller.targetBp.value),
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.medicalGray, thickness: 1),
              const SizedBox(height: 8),

              // ==========================================
              // 2. SUGAR GRAPH SECTION
              // ==========================================
              AppFormSectionHeader(title: 'sugar_graph_title'.tr),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GraphLegendBadge(color: AppColors.error, label: 'fasting'.tr),
                  GraphLegendBadge(color: AppColors.warning, label: 'after_food_or_pp'.tr),
                  GraphLegendBadge(color: AppColors.info, label: 'random'.tr),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: _buildSugarBarChart(context, controller.sugarGraphList),
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.medicalGray, thickness: 1),
              const SizedBox(height: 8),

              // ==========================================
              // 3. LAB PARAMETERS & OTHER VITALS TABLE
              // ==========================================
              AppFormSectionHeader(title: 'other_vitals_title'.tr),
              const SizedBox(height: 12),
              _buildLabParametersTable(controller.otherGraphList),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBPLineChart(BuildContext context, List<BPGraphData> list, TargetBp? target) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          'no_graph_data'.tr,
          style: const TextStyle(color: AppColors.coolGray, fontSize: 13),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width - 24;
    final minPointWidth = 55.0;
    final calculatedWidth = (list.length * minPointWidth).clamp(screenWidth, double.infinity);

    final dates = list.map((e) => _formatDate(e.created)).toList();
    final systolicSpots = <FlSpot>[];
    final diastolicSpots = <FlSpot>[];
    final targetLowSpots = <FlSpot>[];
    final targetHighSpots = <FlSpot>[];

    double minYVal = 300.0;
    double maxYVal = 0.0;

    for (int i = 0; i < list.length; i++) {
      final item = list[i];
      if (item.systolicBp > 0) {
        final val = item.systolicBp.toDouble();
        systolicSpots.add(FlSpot(i.toDouble(), val));
        if (val < minYVal) minYVal = val;
        if (val > maxYVal) maxYVal = val;
      }
      if (item.diastolicBp > 0) {
        final val = item.diastolicBp.toDouble();
        diastolicSpots.add(FlSpot(i.toDouble(), val));
        if (val < minYVal) minYVal = val;
        if (val > maxYVal) maxYVal = val;
      }
      if (target != null) {
        if (target.targetBpSystolic > 0) {
          final tSys = target.targetBpSystolic.toDouble();
          targetHighSpots.add(FlSpot(i.toDouble(), tSys));
          if (tSys > maxYVal) maxYVal = tSys;
        }
        if (target.targetBpDiastolic > 0) {
          final tDia = target.targetBpDiastolic.toDouble();
          targetLowSpots.add(FlSpot(i.toDouble(), tDia));
          if (tDia < minYVal) minYVal = tDia;
        }
      }
    }

    if (minYVal >= 300) minYVal = 60.0;
    if (maxYVal <= 0) maxYVal = 160.0;

    final chartMinY = (minYVal - 20.0).clamp(0.0, 300.0);
    final chartMaxY = (maxYVal + 25.0);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: calculatedWidth,
        height: 240,
        child: LineChart(
          LineChartData(
            minY: chartMinY,
            maxY: chartMaxY,
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => AppColors.navy,
                tooltipMargin: 12,
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    if (spot.barIndex == 0) {
                      return LineTooltipItem(
                        'Systolic: ${spot.y.toInt()}',
                        const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 12),
                      );
                    } else if (spot.barIndex == 1) {
                      return LineTooltipItem(
                        'Diastolic: ${spot.y.toInt()}',
                        const TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 12),
                      );
                    }
                    return null;
                  }).toList();
                },
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => const FlLine(
                color: AppColors.lightGray,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 38,
                  interval: 20,
                  getTitlesWidget: (value, meta) {
                    if (value < chartMinY + 5 || value > chartMaxY - 5) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Text(
                        value.toInt().toString(),
                        style: const TextStyle(color: AppColors.coolGray, fontSize: 10),
                        textAlign: TextAlign.end,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx >= 0 && idx < dates.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          dates[idx],
                          style: const TextStyle(color: AppColors.navy, fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: AppColors.medicalGray, width: 0.8),
            ),
            minX: 0,
            maxX: (list.length - 1).toDouble().clamp(0.0, double.infinity),
            lineBarsData: [
              // Systolic Line
              LineChartBarData(
                spots: systolicSpots,
                isCurved: true,
                color: AppColors.warning,
                barWidth: 3,
                dotData: const FlDotData(show: true),
              ),
              // Diastolic Line
              LineChartBarData(
                spots: diastolicSpots,
                isCurved: true,
                color: AppColors.blue,
                barWidth: 3,
                dotData: const FlDotData(show: true),
              ),
              // Target BP Low Line
              if (targetLowSpots.isNotEmpty)
                LineChartBarData(
                  spots: targetLowSpots,
                  isCurved: false,
                  color: AppColors.teal.withValues(alpha: 0.6),
                  barWidth: 1.5,
                  dashArray: [4, 4],
                  dotData: const FlDotData(show: false),
                ),
              // Target BP High Line
              if (targetHighSpots.isNotEmpty)
                LineChartBarData(
                  spots: targetHighSpots,
                  isCurved: false,
                  color: AppColors.teal.withValues(alpha: 0.6),
                  barWidth: 1.5,
                  dashArray: [4, 4],
                  dotData: const FlDotData(show: false),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSugarBarChart(BuildContext context, List<SugarGraphData> list) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          'no_graph_data'.tr,
          style: const TextStyle(color: AppColors.coolGray, fontSize: 13),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width - 24;
    final minGroupWidth = 70.0;
    final calculatedWidth = (list.length * minGroupWidth).clamp(screenWidth, double.infinity);

    final dates = list.map((e) => _formatDate(e.created)).toList();

    double maxSugarVal = 0.0;
    for (var item in list) {
      final f = _parseDouble(item.fasting);
      final p = _parseDouble(item.afterFood);
      final r = _parseDouble(item.random);
      if (f > maxSugarVal) maxSugarVal = f;
      if (p > maxSugarVal) maxSugarVal = p;
      if (r > maxSugarVal) maxSugarVal = r;
    }
    if (maxSugarVal <= 0) maxSugarVal = 150.0;
    final sugarMaxY = (maxSugarVal + 30.0);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: calculatedWidth,
        height: 240,
        child: BarChart(
          BarChartData(
            maxY: sugarMaxY,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => AppColors.navy,
                tooltipMargin: 12,
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  String label = '';
                  Color color = AppColors.white;
                  if (rodIndex == 0) {
                    label = 'Fasting: ${rod.toY.toInt()}';
                    color = AppColors.error;
                  } else if (rodIndex == 1) {
                    label = 'After Food: ${rod.toY.toInt()}';
                    color = AppColors.warning;
                  } else if (rodIndex == 2) {
                    label = 'Random: ${rod.toY.toInt()}';
                    color = AppColors.info;
                  }
                  return BarTooltipItem(
                    label,
                    TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                  );
                },
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => const FlLine(
                color: AppColors.lightGray,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 38,
                  interval: 30,
                  getTitlesWidget: (value, meta) {
                    if (value > sugarMaxY - 10) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Text(
                        value.toInt().toString(),
                        style: const TextStyle(color: AppColors.coolGray, fontSize: 10),
                        textAlign: TextAlign.end,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx >= 0 && idx < dates.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          dates[idx],
                          style: const TextStyle(color: AppColors.navy, fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: AppColors.medicalGray, width: 0.8),
            ),
            barGroups: List.generate(list.length, (idx) {
              final item = list[idx];
              final fastingVal = _parseDouble(item.fasting);
              final ppVal = _parseDouble(item.afterFood);
              final randomVal = _parseDouble(item.random);

              return BarChartGroupData(
                x: idx,
                barRods: [
                  BarChartRodData(
                    toY: fastingVal,
                    color: AppColors.error,
                    width: 8,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  BarChartRodData(
                    toY: ppVal,
                    color: AppColors.warning,
                    width: 8,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  BarChartRodData(
                    toY: randomVal,
                    color: AppColors.info,
                    width: 8,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildLabParametersTable(List<OtherGraphData> list) {
    if (list.isEmpty) {
      return Container(
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.medicalGray, width: 0.8),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'no_graph_data'.tr,
          style: const TextStyle(color: AppColors.coolGray, fontSize: 13),
        ),
      );
    }

    final dates = list.map((e) => _formatDate(e.date ?? '')).toList();

    final creatinineVals = list.map((e) => e.creatinine ?? '-').toList();
    final cholesterolVals = list.map((e) => e.totalCholesterol ?? '-').toList();
    final bmiVals = list.map((e) => e.bmi ?? '-').toList();
    final urineAlbuminVals = list.map((e) => e.urineAlbumin ?? '-').toList();
    final urineProteinVals = list.map((e) => e.urineProtein ?? '-').toList();
    final uricAcidVals = list.map((e) => e.uricAcid ?? '-').toList();
    final ldlVals = list.map((e) => e.ldl ?? '-').toList();
    final hdlVals = list.map((e) => e.hdl ?? '-').toList();
    final vldlVals = list.map((e) => e.vldl ?? '-').toList();
    final fbsVals = list.map((e) => e.fasting ?? '-').toList();
    final hba1cVals = list.map((e) => e.hba1c ?? '-').toList();
    final ppbsVals = list.map((e) => e.afterFood ?? '-').toList();
    final randomVals = list.map((e) => e.random ?? '-').toList();
    final otherVals = list.map((e) => e.other ?? '-').toList();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.medicalGray, width: 0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabParameterTableRow(label: '#', values: dates, isHeader: true),
              LabParameterTableRow(label: 'creatinine'.tr, values: creatinineVals),
              LabParameterTableRow(label: 'cholesterol'.tr, values: cholesterolVals),
              LabParameterTableRow(label: 'bmi'.tr, values: bmiVals),
              LabParameterTableRow(label: 'urine_albumin'.tr, values: urineAlbuminVals),
              LabParameterTableRow(label: 'urine_protein'.tr, values: urineProteinVals),
              LabParameterTableRow(label: 'uric_acid'.tr, values: uricAcidVals),
              LabParameterTableRow(label: 'ldl'.tr, values: ldlVals),
              LabParameterTableRow(label: 'hdl'.tr, values: hdlVals),
              LabParameterTableRow(label: 'vldl_txt'.tr, values: vldlVals),
              LabParameterTableRow(label: 'fbs'.tr, values: fbsVals),
              LabParameterTableRow(label: 'hba1c'.tr, values: hba1cVals),
              LabParameterTableRow(label: 'ppbs_'.tr, values: ppbsVals),
              LabParameterTableRow(label: 'random'.tr, values: randomVals),
              LabParameterTableRow(label: 'other'.tr, values: otherVals),
            ],
          ),
        ),
      ),
    );
  }
}

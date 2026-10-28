import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/patient_dashboard_controller.dart';
import '../../core/theme/app_colors.dart';

class ExpandableFabMenu extends StatefulWidget {
  final PatientDashboardController controller;

  const ExpandableFabMenu({
    super.key,
    required this.controller,
  });

  @override
  State<ExpandableFabMenu> createState() => _ExpandableFabMenuState();
}

class _ExpandableFabMenuState extends State<ExpandableFabMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _expandAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _animController,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  void _close() {
    if (_isOpen) {
      setState(() {
        _isOpen = false;
        _animController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ctrl = widget.controller;
      final showMedicalForm = ctrl.rxMedicalForm.value != "1";
      final effectiveUserType = ctrl.loggedInUserType.value.isNotEmpty
          ? ctrl.loggedInUserType.value
          : ctrl.type;
      final isAdmitted = ctrl.rxIsAdmitted.value == "1";
      final showAdmitOptions =
          (effectiveUserType == "Doctor" || effectiveUserType == "Nurse") &&
              isAdmitted;

      // Build menu items list:
      // 1. Blood Pressure
      // 2. Blood Sugar
      // 3. Blood Tests
      // 4. Weight
      // 5. Episode
      // 6. Medical Form (if medicalForm != 1)
      // 7. Admit Dashboard (if Doctor/Nurse && isAdmitted)
      // 8. Admit Chat (if Doctor/Nurse && isAdmitted)
      final List<_FabMenuItem> items = [
        _FabMenuItem(
          label: 'blood_pressure'.tr,
          icon: Icons.favorite,
          onTap: () {
            _close();
            ctrl.handleOpenQuickForm();
          },
        ),
        _FabMenuItem(
          label: 'blood_sugar'.tr,
          icon: Icons.bloodtype,
          onTap: () {
            _close();
            ctrl.handleOpenQuickForm();
          },
        ),
        _FabMenuItem(
          label: 'blood_tests'.tr,
          icon: Icons.science,
          onTap: () {
            _close();
            ctrl.handleOpenQuickForm();
          },
        ),
        _FabMenuItem(
          label: 'weight'.tr,
          icon: Icons.monitor_weight,
          onTap: () {
            _close();
            ctrl.handleOpenQuickForm();
          },
        ),
        _FabMenuItem(
          label: 'episode'.tr,
          icon: Icons.warning_amber_rounded,
          onTap: () {
            _close();
            ctrl.handleOpenQuickForm();
          },
        ),
        if (showMedicalForm)
          _FabMenuItem(
            label: 'medical_form'.tr,
            icon: Icons.assignment,
            onTap: () {
              _close();
              ctrl.handleOpenMedicalForm();
            },
          ),
        if (showAdmitOptions) ...[
          _FabMenuItem(
            label: 'admit_dashboard'.tr,
            icon: Icons.local_hospital,
            onTap: () {
              _close();
            },
          ),
          _FabMenuItem(
            label: 'admit_chat'.tr,
            icon: Icons.chat,
            onTap: () {
              _close();
            },
          ),
        ],
      ];

      return Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          // Semi-transparent backdrop when open
          if (_isOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _close,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: AppColors.pureBlack.withValues(alpha: 0.35),
                ),
              ),
            ),
          // Vertical items column
          Positioned(
            right: 16,
            bottom: 84,
            child: AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _expandAnimation,
                  child: ScaleTransition(
                    scale: _expandAnimation,
                    alignment: Alignment.bottomRight,
                    child: child,
                  ),
                );
              },
              child: IgnorePointer(
                ignoring: !_isOpen,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Label pill
                          Material(
                            color: AppColors.white.withValues(alpha: 0),
                            child: InkWell(
                              onTap: item.onTap,
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.teal,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.pureBlack.withValues(alpha: 0.15),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  item.label,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Mini FAB
                          FloatingActionButton.small(
                            heroTag: null,
                            onPressed: item.onTap,
                            backgroundColor: AppColors.blue,
                            elevation: 4,
                            child: Icon(
                              item.icon,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          // Main Trigger FAB
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              heroTag: 'main_patient_fab',
              onPressed: _toggle,
              backgroundColor: _isOpen ? AppColors.error : AppColors.teal,
              elevation: 6,
              shape: const CircleBorder(),
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animController.value * (math.pi / 4), // 45 deg to X
                    child: const Icon(
                      Icons.add,
                      color: AppColors.white,
                      size: 28,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _FabMenuItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  _FabMenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

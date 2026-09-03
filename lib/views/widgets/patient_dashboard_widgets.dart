import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../models/response/patients/slider_response.dart';

class PatientDashboardCircleBtn extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;
  final Color backgroundColor;

  const PatientDashboardCircleBtn({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.iconColor = AppColors.teal,
    this.backgroundColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;
    if (iconPath.endsWith('.svg')) {
      iconWidget = SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        fit: BoxFit.contain,
      );
    } else {
      iconWidget = Image.asset(
        iconPath,
        fit: BoxFit.contain,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor,
                border: Border.all(color: AppColors.medicalGray, width: 1),
              ),
              alignment: Alignment.center,
              child: SizedBox(
                width: 32,
                height: 32,
                child: iconWidget,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientDashboardCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;
  final double cornerRadius;

  const PatientDashboardCard({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.iconColor = AppColors.teal,
    this.textColor = AppColors.navy,
    this.cornerRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;
    if (iconPath.endsWith('.svg')) {
      iconWidget = SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        fit: BoxFit.contain,
      );
    } else {
      iconWidget = Image.asset(
        iconPath,
        fit: BoxFit.contain,
      );
    }

    return Card(
      color: AppColors.white,
      elevation: 2,
      shadowColor: AppColors.lightGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(cornerRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: iconWidget,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PatientDashboardSlider extends StatefulWidget {
  final List<SliderItem> items;
  const PatientDashboardSlider({super.key, required this.items});

  @override
  State<PatientDashboardSlider> createState() => _PatientDashboardSliderState();
}

class _PatientDashboardSliderState extends State<PatientDashboardSlider> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (widget.items.isEmpty) return;
      if (_currentPage < widget.items.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return Container(
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.teal,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Text(
          'mh_clinic_promo'.tr,
          style: TextStyle(
            color: AppColors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 160,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Image.network(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.teal,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: AppColors.teal,
                      ),
                    );
                  },
                );
              },
            ),
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.items.length,
                  (index) => Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? AppColors.teal
                          : AppColors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientDashboardVerticalCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;
  final double cornerRadius;

  const PatientDashboardVerticalCard({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.iconColor = AppColors.teal,
    this.textColor = AppColors.navy,
    this.cornerRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;
    if (iconPath.endsWith('.svg')) {
      iconWidget = SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        fit: BoxFit.contain,
      );
    } else {
      iconWidget = Image.asset(
        iconPath,
        fit: BoxFit.contain,
      );
    }

    return Card(
      color: AppColors.white,
      elevation: 2,
      shadowColor: AppColors.lightGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(cornerRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: iconWidget,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BreathingColorWrapper extends StatefulWidget {
  final Widget Function(BuildContext context, Color animatedColor) builder;
  final Color baseColor;

  const BreathingColorWrapper({
    super.key,
    required this.builder,
    required this.baseColor,
  });

  @override
  State<BreathingColorWrapper> createState() => _BreathingColorWrapperState();
}

class _BreathingColorWrapperState extends State<BreathingColorWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final color = widget.baseColor.withValues(alpha: _animation.value);
        return widget.builder(context, color);
      },
    );
  }
}



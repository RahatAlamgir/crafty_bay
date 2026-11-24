import 'dart:async';

import 'package:crafty_bay/presentation/core/page_indicator.dart';
import 'package:crafty_bay/presentation/feature/home/provider/slide_provider.dart';
import 'package:crafty_bay/presentation/feature/home/widgets/home_banner_slide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Home banner slider. Moves to the next slide by itself every few seconds
/// (back to the first after the last), and pauses while the user is touching
/// it so it never slides away under their finger.
class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  static const double _height = 150;
  static const Duration _autoPlayEvery = Duration(seconds: 4);
  static const Duration _slideDuration = Duration(milliseconds: 500);

  final _controller = PageController();
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_autoPlayEvery, (_) => _showNext());
  }

  void _stopTimer() => _timer?.cancel();

  void _showNext() {
    final count = context.read<SlideProvider>().slides.length;
    if (!_controller.hasClients || count < 2) return;
    _controller.animateToPage(
      (_currentIndex + 1) % count,
      duration: _slideDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SlideProvider>(
      builder: (_, provider, _) {
        if (provider.isLoading && provider.slides.isEmpty) {
          return const SizedBox(
            height: _height,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final slides = provider.slides;
        if (slides.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            SizedBox(
              height: _height,
              // Pauses auto-play while a finger is down, restarts it after,
              // so the next move is a full interval after the last touch.
              child: Listener(
                onPointerDown: (_) => _stopTimer(),
                onPointerUp: (_) => _startTimer(),
                onPointerCancel: (_) => _startTimer(),
                child: PageView.builder(
                  controller: _controller,
                  itemCount: slides.length,
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  itemBuilder: (_, i) => HomeBannerSlide(slide: slides[i]),
                ),
              ),
            ),
            const SizedBox(height: 12),
            PageIndicator(count: slides.length, currentIndex: _currentIndex),
          ],
        );
      },
    );
  }
}

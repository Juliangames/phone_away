import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phone_away/widgets/motivational_sayings.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../widgets/custom_action_button.dart';
import '../theme/theme.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool isRunning = false;
  int selectedSeconds = 1500; // default 25 min
  int remainingSeconds = 1500;
  Timer? timer;

  void startTimer() {
    setState(() {
      isRunning = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      remainingSeconds = selectedSeconds;
    });
  }

  void onTimeChanged(double value) {
    setState(() {
      selectedSeconds = value.toInt();
      remainingSeconds = selectedSeconds;
    });
  }

  String formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final title = isRunning ? 'Stay Focused' : 'Start Focusing';

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Increase height
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0), // Top margin inside AppBar
          child: Text(title),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ), // Optional horizontal padding
        child: LayoutBuilder(
          builder: (context, constraints) {
            const double topMargin = 16.0;
            const double sliderTopMargin = topMargin * 6;
            const double bottomMargin = topMargin;

            return Column(
              children: [
                const SizedBox(height: sliderTopMargin), // Spacer below AppBar
                // Circular Slider or Timer
                Center(
                  child: SizedBox(
                    height: 340,
                    width: 340,
                    child:
                        isRunning
                            ? Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 340,
                                  height: 340,
                                  child: CircularProgressIndicator(
                                    value:
                                        1 -
                                        (remainingSeconds / selectedSeconds),
                                    strokeWidth: 8,
                                    color: AppColors.primaryColor,
                                    backgroundColor:
                                        AppColors.secondaryContainerColor,
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                                Text(
                                  formatTime(remainingSeconds),
                                  style: const TextStyle(fontSize: 32),
                                ),
                              ],
                            )
                            : SleekCircularSlider(
                              min: 0,
                              max: 10000,
                              initialValue: selectedSeconds.toDouble(),
                              onChange: onTimeChanged,
                              innerWidget: (value) {
                                return const Center(
                                  child: Text(
                                    "Image later",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                              appearance: CircularSliderAppearance(
                                customWidths: CustomSliderWidths(
                                  trackWidth: 8,
                                  progressBarWidth: 8,
                                  handlerSize: 8,
                                ),
                                size: 340,
                                startAngle: 270,
                                angleRange: 360,
                                customColors: CustomSliderColors(
                                  progressBarColor: AppColors.primaryColor,
                                  trackColor: AppColors.secondaryContainerColor,
                                  dotColor: AppColors.primaryColor,
                                ),
                                infoProperties: InfoProperties(
                                  modifier: (_) => '',
                                ),
                              ),
                            ),
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  height: 32,
                ), // Space between timer and quote/text
                // Motivational Saying or Time Text
                Center(
                  child:
                      isRunning
                          ? const MotivationalSaying(
                            text: 'Stay focused and keep going! 🔥',
                          )
                          : Text(
                            formatTime(selectedSeconds),
                            style: const TextStyle(fontSize: 42),
                          ),
                ),

                const Spacer(), // Push button to bottom
                // Bottom Button
                Padding(
                  padding: const EdgeInsets.only(bottom: bottomMargin),
                  child: CustomActionButton(
                    onPressed: () {
                      if (isRunning) {
                        stopTimer();
                      } else {
                        startTimer();
                      }
                    },
                    text: isRunning ? 'Stop' : 'Start',
                    icon: isRunning ? Icons.stop : Icons.play_arrow,
                    isError: isRunning,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
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
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: Column(
        children: [
          // This Expanded widget pushes the timer to the middle
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250,
                    width: 250,
                    child:
                        isRunning
                            ? Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 250,
                                  height: 250,
                                  child: CircularProgressIndicator(
                                    value:
                                        1 -
                                        (remainingSeconds / selectedSeconds),
                                    strokeWidth: 8,
                                    color: AppColors.primaryColor,
                                    backgroundColor: Colors.grey.shade300,
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
                              onChange: (value) {
                                onTimeChanged(value);
                              },
                              innerWidget: (value) {
                                return Center(
                                  child: Text(
                                    "Image later",
                                    style: const TextStyle(
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
                                  shadowWidth: 0,
                                  handlerSize: 8,
                                ),
                                size: 250,
                                startAngle: 270,
                                angleRange: 360,
                                customColors: CustomSliderColors(
                                  progressBarColor: AppColors.primaryColor,
                                  trackColor: AppColors.secondaryContainerColor,
                                  dotColor: AppColors.primaryColor,
                                ),
                                infoProperties: InfoProperties(
                                  modifier: (double value) => '',
                                ),
                              ),
                            ),
                  ),
                  const SizedBox(height: 24),
                  if (!isRunning)
                    Text(
                      formatTime(selectedSeconds),
                      style: const TextStyle(fontSize: 42),
                    ),
                ],
              ),
            ),
          ),
          // This container holds the button at the bottom
          // At the bottom of your Column (where the button is)
          CustomActionButton(
            onPressed: () {
              if (isRunning) {
                stopTimer();
              } else {
                startTimer();
              }
            },
            text: isRunning ? 'Stop' : 'Start',
            icon: isRunning ? Icons.stop : Icons.play_arrow,
          ),
        ],
      ),
    );
  }
}

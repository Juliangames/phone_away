import 'package:flutter/material.dart';
import 'package:phone_away/services/timer_service.dart';
import 'package:phone_away/widgets/motivational_sayings.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../theme/theme.dart';
import '../widgets/custom_action_button.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final TimerService _timerService = TimerService();
  int selectedSeconds = 1500; // default 25 min

  void onTimeChanged(double value) {
    setState(() {
      selectedSeconds = value.toInt();
    });
  }

  String formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Timer"), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Center(
                    child: SizedBox(
                      height: 340,
                      width: 340,
                      child: StreamBuilder<int>(
                        stream: _timerService.timeStream,
                        builder: (context, snapshot) {
                          final remaining = snapshot.data ?? selectedSeconds;
                          final isRunning = _timerService.isRunning;

                          return isRunning
                              ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 340,
                                    height: 340,
                                    child: CircularProgressIndicator(
                                      value: 1 - (remaining / selectedSeconds),
                                      strokeWidth: 8,
                                      color: AppColors.primaryColor,
                                      backgroundColor:
                                          AppColors.secondaryContainerColor,
                                      strokeCap: StrokeCap.round,
                                    ),
                                  ),
                                  Text(
                                    formatTime(remaining),
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
                                    trackColor:
                                        AppColors.secondaryContainerColor,
                                    dotColor: AppColors.primaryColor,
                                  ),
                                  infoProperties: InfoProperties(
                                    modifier: (_) => '',
                                  ),
                                ),
                              );
                        },
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Centered Motivational Saying or Time
                  StreamBuilder<int>(
                    stream: _timerService.timeStream,
                    builder: (context, snapshot) {
                      final isRunning = _timerService.isRunning;
                      final remaining = snapshot.data ?? selectedSeconds;

                      return Center(
                        child:
                            isRunning
                                ? const MotivationalSaying(
                                  text: 'Stay focused and keep going!',
                                )
                                : Text(
                                  formatTime(selectedSeconds),
                                  style: const TextStyle(fontSize: 42),
                                ),
                      );
                    },
                  ),

                  // Action Button
                  StreamBuilder<int>(
                    stream: _timerService.timeStream,
                    builder: (context, snapshot) {
                      final isRunning = _timerService.isRunning;

                      return CustomActionButton(
                        onPressed: () {
                          if (isRunning) {
                            _timerService.stop();
                          } else {
                            _timerService.start(selectedSeconds);
                          }
                        },
                        text: isRunning ? 'Stop' : 'Start',
                        icon: isRunning ? Icons.stop : Icons.play_arrow,
                        isError: isRunning,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:phone_away/core/services/db_service.dart';
import 'package:phone_away/widgets/motivational_sayings.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../core/services/timer_service.dart';
import '../../theme/theme.dart';
import '../../widgets/custom_action_button.dart';

class TimerPage extends StatefulWidget {
  final String userId;
  const TimerPage({super.key, required this.userId});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late final TimerService _timerService;
  int selectedSeconds = 1500; // default 25 min

  @override
  void initState() {
    super.initState();
    _timerService = TimerService(userId: widget.userId, dbService: DBService());
  }

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

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              isRunning
                                  ? SizedBox(
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
                                  )
                                  : SleekCircularSlider(
                                    min: 0,
                                    max: 3000,
                                    initialValue: selectedSeconds.toDouble(),
                                    onChange: onTimeChanged,
                                    innerWidget: (_) => const SizedBox.shrink(),
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
                                        progressBarColor:
                                            AppColors.primaryColor,
                                        trackColor:
                                            AppColors.secondaryContainerColor,
                                        dotColor: AppColors.primaryColor,
                                      ),
                                      infoProperties: InfoProperties(
                                        modifier: (_) => '',
                                      ),
                                    ),
                                  ),
                              Text(
                                formatTime(
                                  isRunning ? remaining : selectedSeconds,
                                ),
                                style: const TextStyle(fontSize: 32),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Centered Motivational Saying or Time
                  // Centered Motivational Saying or Time
                  StreamBuilder<int>(
                    stream: _timerService.timeStream,
                    builder: (context, snapshot) {
                      final isRunning = _timerService.isRunning;
                      final saying =
                          isRunning
                              ? 'Stay focused and keep going!'
                              : 'Set a goal and earn apples!';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Center(child: MotivationalSaying(text: saying)),
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

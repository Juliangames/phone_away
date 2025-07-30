import 'package:flutter/material.dart';
import 'package:phone_away/core/providers/user_repository_provider.dart';
import 'package:phone_away/widgets/common/motivational_sayings.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../core/services/timer_service.dart';
import '../../theme/app_constants.dart';
import '../../widgets/buttons/custom_action_button.dart';
import 'timer_constants.dart';

class TimerPage extends StatefulWidget {
  final String userId;
  const TimerPage({super.key, required this.userId});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late final TimerService _timerService;
  int selectedSeconds = AppValues.defaultTimerSeconds; // default 25 min

  @override
  void initState() {
    super.initState();
    _timerService = TimerService(
      userId: widget.userId,
      userRepository: UserRepositoryProvider.instance,
    );
  }

  void onTimeChanged(double value) {
    setState(() {
      selectedSeconds = value.toInt();
    });
  }

  String formatTime(int seconds) {
    final min = (seconds ~/ AppValues.secondsPerMinute).toString().padLeft(
          AppValues.padLength,
          AppStrings.padCharacter,
        );
    final sec = (seconds % AppValues.secondsPerMinute).toString().padLeft(
          AppValues.padLength,
          AppStrings.padCharacter,
        );
    return '$min${AppStrings.timeSeparator}$sec';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TimerConstants.pageTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.mediumSpacing,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Center(
                    child: SizedBox(
                      height: AppDimensions.sliderSize,
                      width: AppDimensions.sliderSize,
                      child: StreamBuilder<int>(
                        stream: _timerService.timeStream,
                        builder: (context, snapshot) {
                          final remaining = snapshot.data ?? selectedSeconds;
                          final isRunning = _timerService.isRunning;

                          final totalSeconds = isRunning
                              ? _timerService.totalDuration
                              : selectedSeconds;

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              isRunning
                                  ? SizedBox(
                                      width: AppDimensions.sliderSize,
                                      height: AppDimensions.sliderSize,
                                      child: CircularProgressIndicator(
                                        value: 1 - (remaining / totalSeconds),
                                        strokeWidth: AppDimensions.strokeWidth,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.secondaryContainer,
                                        strokeCap: StrokeCap.round,
                                      ),
                                    )
                                  : SleekCircularSlider(
                                      min: AppValues.minSliderValue,
                                      max: AppValues.maxSliderValue,
                                      initialValue: selectedSeconds.toDouble(),
                                      onChange: onTimeChanged,
                                      innerWidget: (_) =>
                                          const SizedBox.shrink(),
                                      appearance: CircularSliderAppearance(
                                        customWidths: CustomSliderWidths(
                                          trackWidth: AppDimensions.strokeWidth,
                                          progressBarWidth:
                                              AppDimensions.strokeWidth,
                                          handlerSize:
                                              AppDimensions.strokeWidth,
                                        ),
                                        size: AppDimensions.sliderSize,
                                        startAngle: AppValues.startAngle,
                                        angleRange: AppValues.angleRange,
                                        customColors: CustomSliderColors(
                                          progressBarColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          trackColor: Theme.of(
                                            context,
                                          ).colorScheme.secondaryContainer,
                                          dotColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
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
                                style: const TextStyle(
                                  fontSize: AppTypography.timerFontSize,
                                ),
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
                      final saying = isRunning
                          ? TimerConstants.focusedMotivationalText
                          : TimerConstants.defaultMotivationalText;

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: TimerConstants.bottomPadding,
                        ),
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
                        text: isRunning
                            ? TimerConstants.stopButtonText
                            : TimerConstants.startButtonText,
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

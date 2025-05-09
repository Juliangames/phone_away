import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circle: Either time picker or progress
            SizedBox(
              height: 250,
              width: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value:
                        isRunning
                            ? 1 - (remainingSeconds / selectedSeconds)
                            : 0,
                    strokeWidth: 6,
                  ),
                  isRunning
                      ? Text(
                        formatTime(remainingSeconds),
                        style: const TextStyle(fontSize: 32),
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
                            progressBarColor: Colors.deepPurple,
                            trackColor: Colors.grey.shade300,
                            dotColor: Colors.deepPurpleAccent,
                          ),
                          infoProperties: InfoProperties(
                            modifier: (double value) => '',
                          ),
                        ),
                      ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Display time (only when NOT running)
            if (!isRunning)
              Text(
                formatTime(selectedSeconds),
                style: const TextStyle(fontSize: 24),
              ),

            const SizedBox(height: 32),

            // Start / Stop button
            ElevatedButton(
              onPressed: isRunning ? stopTimer : startTimer,
              child: Text(isRunning ? 'Stop' : 'Start'),
            ),
          ],
        ),
      ),
    );
  }
}

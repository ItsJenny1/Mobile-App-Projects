import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bouncing Ball'), 
        ),
        backgroundColor: Color.fromARGB(255, 90, 111, 117), 
        body: Center(
          child: ballConatiner(), 
        ),
      ),
    );
  }
}

class ballConatiner extends StatefulWidget {
  const ballConatiner({Key? key}) : super(key: key);

  @override
  _ballConatinerState createState() => _ballConatinerState();
}

class _ballConatinerState extends State<ballConatiner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Color _ballColor = Color.fromARGB(255, 188, 93, 138);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    _controller.repeat(reverse: true);
  }

  void stopAnimation() {
    _controller.stop();
  }

  void changeColor(Color color) {
    setState(() {
      _ballColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 12, 215, 127), 
            border: Border.all(
              color: Colors.black, 
              width: 1.0,
            ),
          ),
          child: Center(
            child: Transform.translate(
              offset: Offset(
                0,
                100 * _animation.value,
              ),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _ballColor, 
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: startAnimation,
              child: const Text('Start'),
            ),
          
            ElevatedButton(
              onPressed: () =>
                  changeColor(Color.fromARGB(255, 216, 29, 191)), 
              style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 216, 29, 191)),
              child: const Text(''),
            ),
            ElevatedButton(
              onPressed: () =>
                  changeColor(Color.fromARGB(255, 22, 190, 246)), 
              style: ElevatedButton.styleFrom(primary: const Color.fromARGB(255, 22, 190, 246)),
              child: const Text(''),
            ),
            ElevatedButton(
              onPressed: () =>
                  changeColor(Color.fromRGBO(255, 251, 118, 1)), 
              style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(255, 251, 118, 1)),
              child: const Text(''),
            ),
              ElevatedButton(
              onPressed: stopAnimation,
              child: const Text('Stop'),
            ),
          ],
        ),
      ],
    );
  }
}

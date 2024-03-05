//Sydney Bynoe , Jennifer A.
// secret code = valentines02$ CASHHH MONEEEYYYYYY
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Page'),
        backgroundColor: Color.fromARGB(255, 0, 0, 139),
      ),
      backgroundColor: Color.fromARGB(255, 0, 0, 139),
      body: Center(
        child: ElevatedButton(
          child: Text('Heart'),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HeartAndSparkles()));
          },
        ),
      ),
    );
  }
}

class HeartAndSparkles extends StatefulWidget {
  @override
  _HeartAndSparklesState createState() => _HeartAndSparklesState();
}

class _HeartAndSparklesState extends State<HeartAndSparkles> {
  final SparkleManager _sparkleManager = SparkleManager();
  Timer? _timer;
  int _countdown = 10; // Initialize the countdown timer

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Start the sparkles animation
      _timer = Timer.periodic(Duration(milliseconds: 50), (Timer timer) {
        _sparkleManager.generate(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height);
        setState(() {
          _sparkleManager.update();
        });
      });

      // Start the countdown timer
      Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (_countdown > 0) {
          setState(() {
            _countdown--;
          });
        } else {
          timer.cancel();
          Navigator.of(context).pop(); // Navigate back after countdown
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Happy                          Day',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          CustomPaint(
            size: Size.infinite,
            painter: SparklePainter(particles: _sparkleManager.particles),
          ),
          HeartAnimation(),
          Positioned(
            top: 50, // Position the timer at the top of the screen
            child: Text(
              'Time Left: $_countdown',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class HeartAnimation extends StatefulWidget {
  @override
  _HeartAnimationState createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.4).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Transform.scale(
        scale: _animation.value,
        child: Icon(Icons.favorite, color: Colors.red, size: 100),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SparkleManager {
  List<SparkleParticle> particles = [];
  final int maxParticles = 50;
  final math.Random rand = math.Random();

  void generate(double maxWidth, double maxHeight) {
    if (particles.length < maxParticles) {
      particles.add(SparkleParticle(
        position: Offset(rand.nextDouble() * maxWidth, 0),
        velocity: Offset(0, rand.nextDouble() * 4 + 2),
        color: Colors.white,
        size: rand.nextDouble() * 2 + 1,
      ));
    }
  }

  void update() {
    for (var particle in particles) {
      particle.position += particle.velocity;
    }
    particles.removeWhere((particle) =>
        particle.position.dy > 800); // Adjust based on your screen size
  }
}

class SparkleParticle {
  Offset position;
  Offset velocity;
  Color color;
  double size;

  SparkleParticle(
      {required this.position,
      required this.velocity,
      required this.color,
      required this.size});
}

class SparklePainter extends CustomPainter {
  final List<SparkleParticle> particles;

  SparklePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      var paint = Paint()..color = particle.color;
      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

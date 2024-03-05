import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color.fromARGB(255, 0, 0, 139),
      ),
      
      home: Scaffold(
        body: CalculateDesign(),
      ),
    );
  }
}

class CalculateDesign extends StatefulWidget {
  @override
  _CalculateDesignState createState() => _CalculateDesignState();
}

class _CalculateDesignState extends State<CalculateDesign> {
  String pickedNum = ''; // Variable to store the selected number

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pickedNum.isNotEmpty)
              // Displays a white textbox if a number is selected
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Text(
                  pickedNum,
                  style: TextStyle(fontSize: 40, color: Colors.black),
                ),
              ),
            GridView.count(
              crossAxisCount: 4,
              // makes it so its 4 buttons per row
              shrinkWrap: true,
              children: [
                '1','2','3','+',
                '4','5','6','-',
                '7','8','9','*',
                'C','0','/','=',
              ].map((number) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (number == '=') {
                        //gets the total of the equation when equal is pressed
                        if (pickedNum.contains('+')) {
                          List<String> tokens = pickedNum.split('+');
                          int num1 = int.parse(tokens[0]);
                          int num2 = int.parse(tokens[1]);
                          pickedNum = (num1 + num2).toString();
                        } else if (pickedNum.contains('-')) {
                          List<String> tokens = pickedNum.split('-');
                          int num1 = int.parse(tokens[0]);
                          int num2 = int.parse(tokens[1]);
                          pickedNum = (num1 - num2).toString();
                        } else if (pickedNum.contains('*')) {
                          List<String> tokens = pickedNum.split('*');
                          int num1 = int.parse(tokens[0]);
                          int num2 = int.parse(tokens[1]);
                          pickedNum = (num1 * num2).toString();
                        } else if (pickedNum.contains('/')) {
                          List<String> tokens = pickedNum.split('/');
                          int num1 = int.parse(tokens[0]);
                          int num2 = int.parse(tokens[1]);
                          if (num2 != 0) {
                            // Check for division by zero
                            pickedNum = (num1 ~/ num2).toString();
                          } else {
                            // makes erro for /0
                            pickedNum = 'Error';
                          }
                        }
                      } else if (number == 'C') {
                        pickedNum = ''; // Clears numbers
                      } else if (number == '⌫') {
                        if (pickedNum.isNotEmpty) {
                          pickedNum = pickedNum.substring(
                              0,
                              pickedNum.length -
                                  1);
                        }
                      } else {
                        pickedNum +=
                            number; // Append the number to the selected number
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: number == '='
                          ? Colors.blue
                          : Colors.blue[400], 
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      number,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

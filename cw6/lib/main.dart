import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color beigeColor = Color.fromARGB(255, 245, 245, 220); 

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor:
            beigeColor, 
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.brown), 
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Colors.brown), 
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Main App'),
          backgroundColor: beigeColor,
        ),
        body: TaskListScreen(),
      ),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  List<DayTasks> dayTasksList = [];

  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    
    loadTasks();
  }

  
  void loadTasks() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('tasks').get();

    setState(() {
      dayTasksList = snapshot.docs.map((doc) {
        List<TimeSlot> timeSlots = List<TimeSlot>.from(
          doc['timeSlots'].map((slot) => TimeSlot.fromMap(slot)),
        );
        return DayTasks(
          day: DateTime.parse(doc['day']),
          timeSlots: timeSlots,
        );
      }).toList();
    });
  }

  
  void addTask(String task) async {
    DayTasks dayTasks = dayTasksList.firstWhere(
      (element) => element.day == selectedDate,
      orElse: () {
        DayTasks newDayTasks = DayTasks(day: selectedDate, timeSlots: []);
        dayTasksList.add(newDayTasks);
        return newDayTasks;
      },
    );

   
    dayTasks.timeSlots.add(TimeSlot(task: task, time: selectedTime));
    taskController.clear();

    
    await updateTasksInFirebase();
  }

  
  void removeTask(int dayIndex, int timeIndex) async {
    dayTasksList[dayIndex].timeSlots.removeAt(timeIndex);
    if (dayTasksList[dayIndex].timeSlots.isEmpty) {
      dayTasksList.removeAt(dayIndex);
    }

    
    await updateTasksInFirebase();
  }

  
  void toggleTaskCompletion(int dayIndex, int timeIndex) async {
    dayTasksList[dayIndex].timeSlots[timeIndex].completed =
        !dayTasksList[dayIndex].timeSlots[timeIndex].completed;

    
    await updateTasksInFirebase();
  }

  
  Future<void> updateTasksInFirebase() async {
    await FirebaseFirestore.instance.collection('tasks').doc('tasks').set({
      'tasks': dayTasksList
          .map((dayTasks) => {
                'day': dayTasks.day.toIso8601String(),
                'timeSlots': dayTasks.timeSlots
                    .map((timeSlot) => timeSlot.toMap())
                    .toList(),
              })
          .toList(),
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  'Select Date',
                  style:
                      TextStyle(color: Colors.black), 
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Selected Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}', 
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text(
                  'Select Time',
                  style:
                      TextStyle(color: Colors.black), 
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Selected Time: ${selectedTime.hour}:${selectedTime.minute}', 
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            controller: taskController,
            decoration: InputDecoration(
              labelText: 'Enter Task',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => addTask(taskController.text),
            child: Text(
              'Add Task',
              style: TextStyle(color: Colors.black), 
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: dayTasksList.length,
              itemBuilder: (context, dayIndex) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${DateFormat('dd/MM/yyyy').format(dayTasksList[dayIndex].day)}', 
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dayTasksList[dayIndex].timeSlots.length,
                      itemBuilder: (context, timeIndex) {
                        return ListTile(
                          leading: Checkbox(
                            value: dayTasksList[dayIndex]
                                .timeSlots[timeIndex]
                                .completed,
                            onChanged: (value) =>
                                toggleTaskCompletion(dayIndex, timeIndex),
                          ),
                          title: Text(
                            dayTasksList[dayIndex].timeSlots[timeIndex].task,
                            style: TextStyle(
                              decoration: dayTasksList[dayIndex]
                                      .timeSlots[timeIndex]
                                      .completed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                              '${dayTasksList[dayIndex].timeSlots[timeIndex].time.hour}:${dayTasksList[dayIndex].timeSlots[timeIndex].time.minute}'), 
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => removeTask(dayIndex, timeIndex),
                          ),
                        );
                      },
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ViewTasksScreen(dayTasksList: dayTasksList),
                ),
              );
            },
            child: Text(
              'View Tasks',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class DayTasks {
  final DateTime day;
  List<TimeSlot> timeSlots;

  DayTasks({required this.day, required this.timeSlots});
}

class TimeSlot {
  final String task;
  final TimeOfDay time;
  bool completed;

  TimeSlot({required this.task, required this.time, this.completed = false});

  
  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'hour': time.hour,
      'minute': time.minute,
      'completed': completed,
    };
  }

  
  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      task: map['task'],
      time: TimeOfDay(hour: map['hour'], minute: map['minute']),
      completed: map['completed'],
    );
  }
}

class ViewTasksScreen extends StatelessWidget {
  final List<DayTasks> dayTasksList;

  ViewTasksScreen({required this.dayTasksList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Tasks'),
      ),
      body: ListView.builder(
        itemCount: dayTasksList.length,
        itemBuilder: (context, dayIndex) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date: ${DateFormat('dd/MM/yyyy').format(dayTasksList[dayIndex].day)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: dayTasksList[dayIndex].timeSlots.length,
                itemBuilder: (context, timeIndex) {
                  final TimeSlot task =
                      dayTasksList[dayIndex].timeSlots[timeIndex];
                  return ListTile(
                    leading: Checkbox(
                      value: task.completed,
                      onChanged: (value) {
                        task.completed = value!;
                       
                      },
                    ),
                    title: Text(
                      task.task,
                      style: TextStyle(
                        decoration:
                            task.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text('${task.time.hour}:${task.time.minute}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        
                        dayTasksList[dayIndex].timeSlots.removeAt(timeIndex);
                        
                      },
                    ),
                  );
                },
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color beigeColor = Color.fromARGB(255, 245, 245, 220); // Define beige color

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor:
            beigeColor, // Set scaffold background color to beige
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.brown), // Set text color to brown
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Colors.brown), // Set button background color to brown
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
  List<Todo> addtoList = [];

  TextEditingController taskController = TextEditingController();

  void addTask(String task) {
    setState(() {
      addtoList.add(Todo(task: task, completed: false));
      taskController.clear();
    });
  }

  void removeTask(int index) {
    setState(() {
      addtoList.removeAt(index);
    });
  }

  void toggleTask(int index) {
    setState(() {
      addtoList[index].completed = !addtoList[index].completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
              style: TextStyle(color: Colors.black), // Set text color to black
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: addtoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Checkbox(
                        value: addtoList[index].completed,
                        onChanged: (value) => toggleTask(index),
                      ),
                      Expanded(
                        child: Text(
                          addtoList[index].task,
                          style: addtoList[index].completed
                              ? TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.red)
                              : null,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => removeTask(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Todo {
  final String task;
  bool completed;

  Todo({
    required this.task,
    required this.completed,
  });
}

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/core/helpers/database_helper.dart';
import 'package:todo/core/helpers/page_helper.dart';
import 'package:todo/core/models/task_model.dart';

import 'add_task_screen.dart';

class TodoListScreeen extends StatefulWidget {
  final int index;

  const TodoListScreeen({Key key, @required this.index}) : super(key: key);
  @override
  _TodoListScreeenState createState() => _TodoListScreeenState();
}

class _TodoListScreeenState extends State<TodoListScreeen> {
  Future<List<Task>> _taskList;
  final DateFormat _dateFormat = DateFormat('MMM dd,yyyy');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList(index: widget.index);
    });
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                  fontSize: 18,
                  decoration: task.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text('${_dateFormat.format(task.date)} ${task.priority}',
                style: TextStyle(
                    fontSize: 15,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough)),
            trailing: Checkbox(
                onChanged: (value) {
                  task.status = value ? 1 : 0;
                  DatabaseHelper.instance.updateTask(task);
                  _updateTaskList();
                  print(value);
                },
                activeColor: Theme.of(context).primaryColor,
                value: task.status == 1 ? true : false),
            onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (_) => AddTaskSreen(
                          task: task,
                          index: widget.index,
                          updateTaskList: _updateTaskList,
                        ))),
          ),
          Divider()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) => AddTaskSreen(
                        updateTaskList: _updateTaskList,
                        index: widget.index,
                      )));
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final int completedTaskCount = snapshot.data
                .where((Task task) => task.status == 1)
                .toList()
                .length;

            return Column(
              children: [
                Container(
                  height: 600,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 80),
                    itemCount: 1 + snapshot.data.length,
                    itemBuilder: (BuildContext context, int i) {
                      if (i == 0) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                PageHelper().indexToPage(widget.index),
                                style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '$completedTaskCount/${snapshot.data.length}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        );
                      }
                      return _buildTask(snapshot.data[i - 1]);
                    },
                  ),
                ),
                DotsIndicator(
                  dotsCount: 3,
                  position: widget.index.toDouble(),
                  axis: Axis.vertical,
                  decorator: DotsDecorator(
                    activeColor: Theme.of(context).primaryColor,
                    color: Colors.grey[400],
                  ),
                )
              ],
            );
          }),
    );
  }
}

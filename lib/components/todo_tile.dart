import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoTile extends StatelessWidget {
  final String taskName;
  final bool isDone;
  final Function(bool?) onCheckboxChanged;
  final Function(BuildContext)? onDelete;

  const TodoTile(
      {super.key,
      required this.taskName,
      required this.isDone,
      required this.onCheckboxChanged,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 25.0, left: 25.0, top: 25.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
                onPressed: onDelete,
                icon: Icons.delete,
                backgroundColor: Colors.red),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            children: [
              Checkbox(
                  value: isDone,
                  onChanged: onCheckboxChanged,
                  activeColor: Colors.yellow[800]),
              //task name
              Text(
                taskName,
                style: TextStyle(
                    decoration: isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

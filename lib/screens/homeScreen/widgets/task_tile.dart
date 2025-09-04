import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/controller/db_controller.dart';
import 'package:task_manager_app/models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onEdit;

  const TaskTile({super.key, required this.task, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final db = Get.find<DbController>();
    final deadlineStr = task.deadline != null
        ? DateFormat('dd MMM yyyy • hh:mm a').format(task.deadline!)
        : 'No deadline';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAE6E2)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: (val) {
              if (val == null) return;
              db.toggleCompleted(taskId: task.id, newCompleted: val);
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Multi-line, full title
                      Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Deadline: $deadlineStr',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onEdit,
                    tooltip: 'Edit',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

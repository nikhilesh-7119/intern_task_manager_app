import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/controller/db_controller.dart';
import 'package:task_manager_app/screens/homeScreen/widgets/task_tile.dart';
import 'package:task_manager_app/screens/homeScreen/widgets/task_editor_sheet.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Get.find<DbController>();
    return Obx(() {
      final list = db.tasks;
      if (list.isEmpty) {
        return const Center(child: Text('No tasks yet'));
      }
      return ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final t = list[index];
          return TaskTile(
            task: t,
            onEdit: () => showTaskEditorBottomSheet(context, existing: t),
          );
        },
      );
    });
  }
}

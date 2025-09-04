import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/controller/db_controller.dart';
import 'package:task_manager_app/models/task_model.dart';

Future<void> showTaskEditorBottomSheet(
  BuildContext context, {
  TaskModel? existing,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          top: 16,
        ),
        child: _TaskEditor(existing: existing),
      );
    },
  );
}

class _TaskEditor extends StatefulWidget {
  final TaskModel? existing;
  const _TaskEditor({this.existing});

  @override
  State<_TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<_TaskEditor> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _title.text = widget.existing!.title;
      _deadline = widget.existing!.deadline;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = Get.find<DbController>();
    final isEdit = widget.existing != null;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isEdit ? 'Edit Task' : 'Add Task',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _title,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            maxLines: null,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Title required' : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await _pickDeadline(
                      context,
                      initial: _deadline,
                    );
                    if (picked != null) {
                      setState(() => _deadline = picked);
                    }
                  },
                  icon: const Icon(Icons.event),
                  label: Text(
                    _deadline == null
                        ? 'Pick deadline'
                        : DateFormat(
                            'dd MMM yyyy • hh:mm a',
                          ).format(_deadline!),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(), // Discard
                  child: const Text('Discard'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    try {
                      final title = _title.text.trim();
                      if (isEdit) {
                        await db.editTask(
                          taskId: widget.existing!.id,
                          title: title,
                          deadline: _deadline,
                        );
                      } else {
                        await db.addTask(title: title, deadline: _deadline);
                      }
                      if (mounted) Navigator.of(context).pop();
                    } catch (e) {
                      Get.snackbar('Error', e.toString());
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _pickDeadline(
    BuildContext context, {
    DateTime? initial,
  }) async {
    final now = DateTime.now();
    final init = initial ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (date == null) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(init),
    );
    if (time == null) return DateTime(date.year, date.month, date.day);
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}

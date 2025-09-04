import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager_app/models/task_model.dart';

class DbController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final RxList<TaskModel> tasks = <TaskModel>[].obs;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;

  String get _uid {
    final u = _auth.currentUser;
    if (u == null) throw Exception('Not authenticated');
    return u.uid;
  }

  CollectionReference<Map<String, dynamic>> get _tasksCol =>
      _db.collection('users').doc(_uid).collection('tasks');

  @override
  void onInit() {
    super.onInit();
    _bindTasks();
  }

  void _bindTasks() {
    _sub?.cancel();
    // order by createdAt descending or ascending per preference; here descending newest first
    _sub = _tasksCol.orderBy('createdAt', descending: true).snapshots().listen((
      snap,
    ) {
      final list = snap.docs.map((d) => TaskModel.fromDoc(d)).toList();
      tasks.assignAll(list);
    }, onError: (e) {});
  }

  Future<void> addTask({required String title, DateTime? deadline}) async {
    await _tasksCol.add({
      'title': title,
      'isCompleted': false,
      'deadline': deadline != null ? Timestamp.fromDate(deadline) : null,
      'createdAt': FieldValue.serverTimestamp(), // set on create
    });
  }

  Future<void> editTask({
    required String taskId,
    required String title,
    DateTime? deadline,
  }) async {
    await _tasksCol.doc(taskId).update({
      'title': title,
      'deadline': deadline != null ? Timestamp.fromDate(deadline) : null,
      'createdAt':
          FieldValue.serverTimestamp(), // overwrite on edit per requirement
    });
  }

  Future<void> toggleCompleted({
    required String taskId,
    required bool newCompleted,
  }) async {
    await _tasksCol.doc(taskId).update({'isCompleted': newCompleted});
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksCol.doc(taskId).delete();
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/todo_model.dart';

class ToDoDatabaseService {
  CollectionReference toDoDatabaseService =
      FirebaseFirestore.instance.collection('TodoList');

  Stream<List<ToDoModel>> listToDo() {
    return toDoDatabaseService
        .orderBy("Timestamp", descending: true)
        .snapshots()
        .map(toDoFromFireStore);
  }

  Future createNewTodo(String title) async {
    return await toDoDatabaseService.add({
      "message": title,
      "isCheck": false,
      "Timestamp": FieldValue.serverTimestamp(),
    });
  }

  Future updateTask(uid, bool newCheck) async {
    await toDoDatabaseService.doc(uid).update({"isCheck": newCheck});
  }

  Future deleteTask(uid) async {
    await toDoDatabaseService.doc(uid).delete();
  }

  List<ToDoModel> toDoFromFireStore(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      Map<String, dynamic>? data = e.data() as Map<String, dynamic>?;
      return ToDoModel(
          uid: e.id,
          message: data?['message'] ?? '',
          isCheck: data?['isCheck'] ?? true);
    }).toList();
  }
}

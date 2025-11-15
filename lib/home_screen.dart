import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:untitled6/provider.dart';
import 'model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  Future<void> _showDialog({TODOModel? todo}) async {
    if (todo != null) {
      titleController.text = todo.title;
      descController.text = todo.description ?? "";
    } else {
      titleController.clear();
      descController.clear();
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(todo == null ? 'Add Todo' : 'Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isEmpty) return;

                final provider = context.read<TodoProvider>();

                if (todo == null) {
                  provider.addToDoList(
                    TODOModel(
                      title: titleController.text,
                      description: descController.text,
                      isCompleted: false,
                    ),
                  );
                } else {
                  provider.updateToDo(
                    todo,
                    titleController.text,
                    descController.text,
                  );
                }

                Navigator.pop(context);
              },
              child: Text(todo == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List",style: TextStyle(color: Colors.white),),centerTitle: true,
        backgroundColor: const Color(0xff622CA7),
      ),
      body: ListView.builder(
        itemCount: provider.allTODOList.length,
        itemBuilder: (context, index) {
          final todo = provider.allTODOList[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: MSHCheckbox(
                size: 30,
                value: todo.isCompleted,
                onChanged: (v) => provider.todoStatusChange(todo),
              ),
              title: Text(
                todo.title,
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(todo.description ?? ""),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showDialog(todo: todo),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => provider.removedToDoList(todo),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff622CA7),
        child: const Icon(Icons.add, size: 30,color: Colors.white,),
        onPressed: () => _showDialog(),
      ),
    );
  }
}

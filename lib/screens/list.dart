import 'package:flutter/material.dart';
import 'package:trabalho_tdm/database/tarefa_dao.dart';
import '../models/tarefa.dart';
import 'form.dart';

class ListaTarefa extends StatefulWidget {
  List<Tarefa> _tarefas = [];

  @override
  State<StatefulWidget> createState() {
    return ListaTarefaState();
  }
}

class ListaTarefaState extends State<ListaTarefa> {
  TarefaDao dao = TarefaDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Tarefas"),
          centerTitle: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final Future future =
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FormTarefa();
            }));
            future.then((tarefa) {
              setState(() {});
            });
          },
          child: Icon(Icons.add),
        ),
        body: FutureBuilder<List<Tarefa>>(
            initialData: [],
            future: dao.findAll(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.data != null) {
                    final List<Tarefa>? tarefas = snapshot.data;
                    return ListView.builder(
                        itemCount: tarefas!.length,
                        itemBuilder: (context, indice) {
                          final tarefa = tarefas[indice];
                          return ItemTarefa(context, tarefa);
                        });
                  }
                default:
                  return Center(
                    child: Text(""),
                  );
              }
              return Center(child: Text(""));
            }));
  }

  Widget ItemTarefa(BuildContext context, Tarefa _tarefa) {
    return GestureDetector(
        onTap: () {
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormTarefa(tarefa: _tarefa);
          }));
          future.then((value) => setState(() {}));
        },
        child: Card(
          child: ListTile(
            title: Text(_tarefa.descricao),
            subtitle: Text(_tarefa.obs),
            leading: Icon(Icons.add_alert),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _excluir(context, _tarefa.id);
                  },
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.remove_circle_outline, color: Colors.red)),
                ),
              ],
            ),
          ),
        ));
  }

  void _excluir(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirmação",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            "Tem certeza de que deseja excluir esta tarefa?",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o AlertDialog
              },
            ),
            TextButton(
              child: Text(
                "Excluir",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 17,
                ),
              ),
              onPressed: () {
                dao.delete(id).then((value) {
                  setState(() {});
                  Navigator.of(context).pop(); // Fecha o AlertDialog
                });
              },
            ),
          ],
        );
      },
    );
  }
}

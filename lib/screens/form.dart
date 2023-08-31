import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../components/editor.dart';
import '../database/tarefa_dao.dart';

class FormTarefa extends StatefulWidget {
  final Tarefa? tarefa;
  FormTarefa({this.tarefa});

  @override
  State<StatefulWidget> createState() {
    return FormTarefaState();
  }
}

class FormTarefaState extends State<FormTarefa> {
  final TextEditingController _controladorTarefa = TextEditingController();
  final TextEditingController _controladorObs = TextEditingController();
  int? _id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Tarefas"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Editor(_controladorTarefa, "Tarefa", "Informe a Tarefa", Icons.assignment),
              Editor(_controladorObs, "Notas", "Informe uma Nota", Icons.assignment),
              Container(
                margin: EdgeInsets.only(top: 10), // Define o espaçamento vertical entre o botão e os campos de entrada
                child: ElevatedButton(
                  onPressed: () {
                    if (_validarCampos()) {
                      criarTarefa(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Preencha todos os campos obrigatórios."),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                    textStyle: TextStyle(fontSize: 18),
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text("Salvar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  bool _validarCampos() {
    return _controladorTarefa.text.isNotEmpty && _controladorObs.text.isNotEmpty;
  }

  void criarTarefa(BuildContext context) {
    TarefaDao dao = TarefaDao();
    if (_id != null) {
      final tarefa = Tarefa(
          _id!,
          _controladorTarefa.text,
          _controladorObs.text);
      dao.update(tarefa).then((id) => Navigator.pop(context));
    } else {
      final tarefa = Tarefa(0,
          _controladorTarefa.text,
          _controladorObs.text);
      dao.save(tarefa).then((id) {
        print("Tarefa incluída: " + id.toString());
        Navigator.pop(context);
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tarefa atualizada!"),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.tarefa != null) {
      _id = widget.tarefa!.id;
      _controladorTarefa.text = widget.tarefa!.descricao;
      _controladorObs.text = widget.tarefa!.obs;
    }
  }
}

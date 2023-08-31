import 'package:flutter/material.dart';
import '../models/medicamento.dart';
import '../components/editor.dart';
import '../database/medicamento_dao.dart';

class FormMedicamento extends StatefulWidget {
  final Medicamento? medicamento;
  FormMedicamento({this.medicamento});

  @override
  State<StatefulWidget> createState() {
    return FormMedicamentoState();
  }
}

class FormMedicamentoState extends State<FormMedicamento> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorDescricao = TextEditingController();
  final TextEditingController _controladorQuantidade = TextEditingController();
  final TextEditingController _controladorHorario = TextEditingController();
  int? _id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Medicamentos"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Editor(
                _controladorNome,
                "Nome",
                "Informe o Nome",
                Icons.local_hospital,
              ),
              Editor(
                _controladorDescricao,
                "Descrição",
                "Informe a Descrição",
                Icons.description,
              ),
              Editor(
                _controladorQuantidade,
                "Quantidade",
                "Informe a Quantidade",
                Icons.add_circle_outline,
              ),
              Editor(
                _controladorHorario,
                "Horário",
                "Informe o Horário",
                Icons.access_alarm,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (_validarCampos()) {
                      criarMedicamento(context);
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
    return _controladorNome.text.isNotEmpty &&
        _controladorDescricao.text.isNotEmpty &&
        _controladorQuantidade.text.isNotEmpty &&
        _controladorHorario.text.isNotEmpty;
  }

  void criarMedicamento(BuildContext context) {
    MedicamentoDao dao = MedicamentoDao();
    if (_id != null) {
      final medicamento = Medicamento(
        _id!,
        _controladorNome.text,
        _controladorDescricao.text,
        _controladorQuantidade.text,
        _controladorHorario.text
      );
      dao.update(medicamento).then((id) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Medicamento atualizado!"),
          ),
        );
        Navigator.pop(context);
      });
    } else {
      final medicamento = Medicamento(
        0,
        _controladorNome.text,
        _controladorDescricao.text,
        _controladorQuantidade.text,
        _controladorHorario.text
      );
      dao.save(medicamento).then((id) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Medicamento adicionado!"),
          ),
        );
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.medicamento != null) {
      _id = widget.medicamento!.id;
      _controladorNome.text = widget.medicamento!.nome;
      _controladorDescricao.text = widget.medicamento!.descricao;
      _controladorQuantidade.text = widget.medicamento!.quantidade;
      _controladorHorario.text = widget.medicamento!.horario;
    }
  }
}

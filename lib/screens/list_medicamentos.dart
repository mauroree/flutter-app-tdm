import 'package:flutter/material.dart';
import 'package:trabalho_tdm/database/medicamento_dao.dart';
import '../models/medicamento.dart';
import 'formMedicamento.dart';

class ListaMedicamento extends StatefulWidget {
  List<Medicamento> _medicamentos = [];

  @override
  State<StatefulWidget> createState() {
    return ListaMedicamentoState();
  }
}

class ListaMedicamentoState extends State<ListaMedicamento> {
  MedicamentoDao dao = MedicamentoDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Medicamentos"),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormMedicamento();
          }));
          future.then((medicamento) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Medicamento>>(
        initialData: [],
        future: dao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data != null) {
                final List<Medicamento>? medicamentos = snapshot.data;
                return ListView.builder(
                  itemCount: medicamentos!.length,
                  itemBuilder: (context, indice) {
                    final medicamento = medicamentos[indice];
                    return ItemMedicamento(context, medicamento);
                  },
                );
              }
            default:
              return Center(
                child: Text(""),
              );
          }
          return Center(child: Text(""));
        },
      ),
    );
  }

  Widget ItemMedicamento(BuildContext context, Medicamento _medicamento) {
    return GestureDetector(
      onTap: () {
        final Future future =
            Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FormMedicamento(medicamento: _medicamento);
        }));
        future.then((value) => setState(() {}));
      },
      child: Card(
        child: ListTile(
          title: Text(_medicamento.nome),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_medicamento.descricao),
              Text("Quantidade: ${_medicamento.quantidade}"),
              Text("Horário: ${_medicamento.horario}"),
            ],
          ),
          leading: Icon(Icons.medical_services),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _excluir(context, _medicamento.id);
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.remove_circle_outline, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            "Tem certeza de que deseja excluir este medicamento?",
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

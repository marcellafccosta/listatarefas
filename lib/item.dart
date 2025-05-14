import 'dart:convert';

Item itemFromJson(String str) => Item.fromMap(json.decode(str));

String itemToJson(Item data) => json.encode(data.toMap());

class Item {
  int? id;
  String tarefa;
  bool isChecked;

  Item({
    this.id,
    required this.tarefa,
    required this.isChecked,
  });

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        id: json["id"],
        tarefa: json["tarefa"],
        isChecked: json["isChecked"] == 1,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "tarefa": tarefa,
        "isChecked": isChecked ? 1 : 0,
      };
}

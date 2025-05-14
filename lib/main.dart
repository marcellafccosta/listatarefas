import 'package:flutter/material.dart';
import 'package:listatarefas/database.dart';

import 'item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 131, 136, 203)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lista de Compras'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(widget.title),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Nova tarefa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      String text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        Item novoItem = Item(tarefa: text, isChecked: false);
                        await DBProvider.db.newItem(novoItem);
                        _controller.clear();
                        setState(() {});
                      }
                    },
                    child: const Icon(Icons.add),
                  )
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Item>>(
                future: DBProvider.db.getAllItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Erro ao carregar os itens'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum item encontrado'));
                  } else {
                    final items = snapshot.data!;
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          title: Text(item.tarefa),
                          leading: Checkbox(
                            value: item.isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                item.isChecked = value!;
                              });
                              DBProvider.db.updateItem(item);
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await DBProvider.db.deleteItem(item.id!);
                              setState(() {});
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'sqlite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _journals = [];

  void _refreshJournals() async {
    final data = await SQLite.getItems();
    setState(() {
      _journals = data;
    });
  }

  @override
  initState() {
    super.initState();
    _refreshJournals();
  }

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Future<void> _addItem() async {
    await SQLite.createItem(titleController.text, contentController.text);
    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await SQLite.updateItem(id, titleController.text, contentController.text);
    _refreshJournals();
  }

  void _deleteItem(int id) {
    SQLite.deleteItem(id);
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text(
          'NOTE TAKING',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.text = '';
          contentController.text = '';
          showDialog(
              context: context,
              builder: ((context) => Dialog.fullscreen(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                              child: Text('New Note',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))),
                          const SizedBox(height: 10),
                          TextField(
                            autofocus: true,
                            style: const TextStyle(fontSize: 25),
                            minLines: 1,
                            maxLines: 2,
                            controller: titleController,
                            decoration: InputDecoration(
                                hintText: 'Title',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(fontSize: 20),
                              minLines: 25,
                              maxLines: 25,
                              controller: contentController,
                              decoration: InputDecoration(
                                  hintText: 'Content',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _addItem();
                              },
                              child: const Text('SAVE'))
                        ],
                      ),
                    ),
                  )));
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return GridView.builder(
                itemCount: _journals.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 3 / 5,
                    crossAxisCount:
                        orientation == Orientation.portrait ? 2 : 3),
                itemBuilder: (context, idx) {
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).colorScheme.primary,
                                  offset: const Offset(2.5, 3.5))
                            ],
                            border: Border.all(
                                width: 1.5,
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                          ),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                '${idx + 1}. ${_journals[idx]['title'].toUpperCase()}',
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                children: [
                                  Text(_journals[idx]['content'],
                                      maxLines: 10,
                                      style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ])),
                    ),
                    onTap: () {
                      titleController.text = _journals[idx]['title'];
                      contentController.text = _journals[idx]['content'];
                      showDialog(
                          context: context,
                          builder: ((context) => Dialog.fullscreen(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Note',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary)),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.delete_forever),
                                            onPressed: () {
                                              _deleteItem(_journals[idx]['id']);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      )),
                                      Center(
                                          child: Text(
                                              '(Created At: ${_journals[idx]['createdAt']})',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ))),
                                      const SizedBox(height: 10),
                                      TextField(
                                        autofocus: true,
                                        style: const TextStyle(fontSize: 25),
                                        minLines: 1,
                                        maxLines: 2,
                                        controller: titleController,
                                        decoration: InputDecoration(
                                            hintText: 'Title',
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                      ),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(fontSize: 20),
                                          minLines: 25,
                                          maxLines: 25,
                                          controller: contentController,
                                          decoration: InputDecoration(
                                              hintText: 'Content',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30))),
                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _updateItem(_journals[idx]['id']);
                                          },
                                          child: const Text('SAVE'))
                                    ],
                                  ),
                                ),
                              )));
                      setState(() {});
                    },
                  );
                });
          },
        ),
      ),
    );
  }
}

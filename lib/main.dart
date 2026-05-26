import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class ListItem extends StatelessWidget {
  final IconData iconData;
  final String itemName;
  final String price;
  const ListItem({
    super.key,
    required this.iconData,
    required this.itemName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(itemName),
      subtitle: Text(price),
      trailing: ActionItem(),
    );
  }
}

class ActionItem extends StatefulWidget {
  const ActionItem({super.key});

  @override
  State<ActionItem> createState() => _ActionItemState();
}

class _ActionItemState extends State<ActionItem> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$counter"),
        IconButton(
          onPressed: () {
            setState(() {});
            counter++;
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}

class TipSelector extends StatefulWidget {
  const TipSelector({super.key});

  @override
  State<TipSelector> createState() => _TipSelectorState();
}

class _TipSelectorState extends State<TipSelector> {
  bool addTip = false;
  int selectedTip = 10;
  List<int> tipOptions = [10, 15, 20, 25];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: Text("Add a tip?"),
          value: addTip,
          onChanged: (value) {
            setState(() {
              addTip = value;
            });
          },
        ),
        if (addTip)
          Wrap(
            spacing: 8,
            children: tipOptions.map((tip) {
              return ChoiceChip(
                label: Text("$tip%"),
                selected: selectedTip == tip,
                onSelected: (selected) {
                  setState(() {
                    selectedTip = tip;
                  });
                },
              );
            }).toList(),
          ),
      ],
    );
  }
}

class ConfirmSelection extends StatelessWidget {
  const ConfirmSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Order Confirmed"),
              content: Text("Your checkout order has been submitted"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: Text("Dismiss"))
              ]
            );
          });
      }, 
      child: Text("Confirm Order"));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Checkout'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Column(
                children: [
                  ListItem(
                    iconData: Icons.local_pizza,
                    itemName: "Pizza",
                    price: "15.99",
                  ),
                  ListItem(
                    iconData: Icons.local_cafe,
                    itemName: "Coffee",
                    price: "3.99",
                  ),
                  ListItem(
                    iconData: Icons.icecream,
                    itemName: "Ice Cream",
                    price: "5.99",
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Card(child: TipSelector()),
            SizedBox(height: 15),
            ConfirmSelection(),
          ],
        ),
      ),
    );
  }
}

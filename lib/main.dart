import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

// Data model for an item
class CartItem {
  final String name;
  final IconData icon;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.icon,
    required this.price,
    this.quantity = 0,
  });
}

class ListItem extends StatelessWidget {
  final IconData iconData;
  final String itemName;
  final String price;
  final int quantity;
  final Function(int) onQuantityChanged;

  const ListItem({
    super.key,
    required this.iconData,
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(itemName),
      subtitle: Text(price),
      trailing: ActionItem(
        quantity: quantity,
        onQuantityChanged: onQuantityChanged,
      ),
    );
  }
}

class ActionItem extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;

  const ActionItem({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            if (quantity > 0) {
              onQuantityChanged(quantity - 1);
            }
          },
          icon: Icon(Icons.remove),
        ),
        Text("$quantity"),
        IconButton(
          onPressed: () {
            onQuantityChanged(quantity + 1);
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}

class TipSelector extends StatefulWidget {
  final double subtotal;
  final Function(int) onTipChanged;

  const TipSelector({
    super.key,
    required this.subtotal,
    required this.onTipChanged,
  });
  
  @override
  State<TipSelector> createState() => _TipSelectorState();
}

class _TipSelectorState extends State<TipSelector> {
  bool addTip = false;
  int selectedTip = 10;
  List<int> tipOptions = [10, 15, 20, 25];

  double get tipAmount => addTip ? (widget.subtotal * selectedTip / 100) : 0;
  double get grandTotal => widget.subtotal + tipAmount;

  @override
  Widget build(BuildContext context) {
    return Card( // use a card for more functionality than just a column
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subtotal: \$${widget.subtotal.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            SwitchListTile(
              title: Text("Add a tip?"),
              value: addTip,
              onChanged: (value) {
                setState(() {
                  addTip = value;
                  if (!addTip) {
                    widget.onTipChanged(0);
                  }
                });
              },
            ),
            if (addTip) ...[
              Wrap(
                spacing: 8,
                children: tipOptions.map((tip) {
                  return ChoiceChip(
                    label: Text("$tip%"),
                    selected: selectedTip == tip,
                    onSelected: (selected) {
                      setState(() {
                        selectedTip = tip;
                        widget.onTipChanged(tip);
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 12),
              Text(
                'Tip Amount: \$${tipAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            SizedBox(height: 12),
            Divider(), // Use divider here separate the total from the tip (additional property)
            SizedBox(height: 12),
            Text(
              'Grand Total: \$${grandTotal.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
            ),
          ],
        ),
      ),
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
      home: const MyHomePage(title: 'Kammerer Ramen and Sushi Bar'),
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
  late List<CartItem> items;
  int selectedTipPercent = 0;

  @override
  void initState() {
    super.initState();
    items = [
      CartItem(name: 'Rice Bowl', icon: Icons.rice_bowl, price: 8.99),
      CartItem(name: 'Tea', icon: Icons.emoji_food_beverage, price: 3.99),
      CartItem(name: 'Sushi', icon: Icons.set_meal, price: 8.99),
      CartItem(name: 'Ramen', icon: Icons.ramen_dining, price: 12.99),
    ];
  }

  double calculateSubtotal() {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }



  @override
  Widget build(BuildContext context) {
    double subtotal = calculateSubtotal();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(widget.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            Image.asset(
              'assets/images/wave.png',
              height: 44,
              width: 44,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Column(
                children: items.map((item) {
                  return ListItem(
                    iconData: item.icon,
                    itemName: item.name,
                    price: '\$${item.price.toStringAsFixed(2)}',
                    quantity: item.quantity,
                    onQuantityChanged: (newQuantity) {
                      setState(() {
                        item.quantity = newQuantity;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 15),
            TipSelector(
              subtotal: subtotal,
              onTipChanged: (tipPercent) {
                setState(() {
                  selectedTipPercent = tipPercent;
                });
              },
            ),
            SizedBox(height: 15),
            ConfirmSelection(),
          ],
        ),
      ),
    );
  }
}

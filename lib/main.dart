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
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(iconData, color: Theme.of(context).colorScheme.primary, size: 26),
      ),
      title: Text(itemName, style: TextStyle(fontFamily: 'Ramen', fontSize: 22, fontWeight: FontWeight.w600)),
      subtitle: Text(price, style: TextStyle(fontFamily: 'Ramen', fontSize: 18, fontWeight: FontWeight.w400)),
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
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: IconButton(
            onPressed: () {
              if (quantity > 0) {
                onQuantityChanged(quantity - 1);
              }
            },
            icon: Icon(Icons.remove),
          )),
        SizedBox(width: 12),
        Text("$quantity", style: TextStyle(fontFamily: 'Ramen', fontSize: 18, fontWeight: FontWeight.w500)),
        SizedBox(width: 12),
        CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primaryContainer, 
          child: IconButton(
          onPressed: () {
            onQuantityChanged(quantity + 1);
          },
          icon: Icon(Icons.add),
        ),),
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamily: 'Ramen',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            SwitchListTile(
              title: Text("Add a tip?", style: TextStyle(fontFamily: 'Ramen', fontSize: 18, fontWeight: FontWeight.w400)),
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
                    label: Text("$tip%", style: TextStyle(fontFamily: 'Ramen', fontSize: 16, fontWeight: FontWeight.w400)),
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Ramen',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
            SizedBox(height: 12),
            Divider(), // Use divider here separate the total from the tip (additional property)
            SizedBox(height: 12),
            Text(
              'Grand Total: \$${grandTotal.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'Ramen',
                    fontSize: 20,
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
      child: Text("Confirm Order", style: TextStyle(fontFamily: 'Ramen', fontSize: 18, fontWeight: FontWeight.w600)));
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
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 124, 21, 0)).copyWith(
          primary: Color.fromARGB(255, 124, 21, 0),
          primaryContainer: Color.fromARGB(255, 255, 224, 217),
        ),
      ),
      home: const MyHomePage(title: 'Kammerer Ramen and Sushi Bar'),
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 80,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(widget.title, style: TextStyle(
                fontFamily: 'Ramen',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary
                )),
            ),
            Image.asset(
              'assets/images/wave.png',
              height: 44,
              width: 44,
            ),
          ],
        ),
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [
        //       Theme.of(context).colorScheme.primary,
        //       Theme.of(context).colorScheme.primaryContainer,
        //     ],
        //   ),
        // ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              Card(
                child: Column(
                  children: items.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final CartItem item = entry.value;
                    return Column(
                      children: [
                        ListItem(
                          iconData: item.icon,
                          itemName: item.name,
                          price: '\$${item.price.toStringAsFixed(2)}',
                          quantity: item.quantity,
                          onQuantityChanged: (newQuantity) {
                            setState(() {
                              item.quantity = newQuantity;
                            });
                          },
                        ),
                        if (index < items.length - 1) Divider(), // Add a divider between items
                          ]
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class QuantityIncDec extends StatefulWidget {
  final int currentNumber;
  final Function() onAdd;
  final Function() onRemove;
  const QuantityIncDec({super.key, required this.currentNumber, required this.onAdd, required this.onRemove});

  @override
  State<QuantityIncDec> createState() => _QuantityIncDecState();
}

class _QuantityIncDecState extends State<QuantityIncDec> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.5,
          color: Colors.grey.shade300
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: widget.onRemove,
            icon: Icon(Iconsax.minus),
          ),
          SizedBox(width: 10,),
          Text(
            "${widget.currentNumber}",
            style: TextStyle(
              fontSize: 16,fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(width: 10,),
          IconButton(
            onPressed: widget.onAdd,
            icon: Icon(Iconsax.add),
          ),
        ],
      ),
    );
  }
}

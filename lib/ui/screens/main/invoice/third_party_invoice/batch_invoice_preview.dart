import 'package:flutter/material.dart';

class BatchInvoicePreview extends StatelessWidget {
  const BatchInvoicePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Batch Invoice Preview"),
      ),
      body: Container(
        child: Center(
          child: Text("Batch Invoice Preview"),
        ),
      ),
    );
  }
}
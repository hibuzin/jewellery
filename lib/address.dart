import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateAddressPage extends StatefulWidget {
  const CreateAddressPage({super.key});

  @override
  State<CreateAddressPage> createState() => _CreateAddressPageState();
}

class _CreateAddressPageState extends State<CreateAddressPage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();

  bool isDefault = true;
  bool isLoading = false;

  Future<void> submitAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://jewellery-backend-icja.onrender.com/api/address'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer YOUR_TOKEN', // if required
        },
        body: jsonEncode({
          "name": nameCtrl.text,
          "phone": phoneCtrl.text,
          "street": streetCtrl.text,
          "city": cityCtrl.text,
          "state": stateCtrl.text,
          "pincode": pincodeCtrl.text,
          "isDefault": isDefault,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Address added successfully")),
        );
        Navigator.pop(context, data["address"]);
      } else {
        throw data["message"] ?? "Something went wrong";
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Address")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: isWeb ? 450 : double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isWeb
                  ? [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                )
              ]
                  : [],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _field("Name", nameCtrl),
                  _field("Phone", phoneCtrl,
                      keyboard: TextInputType.phone),
                  _field("Street", streetCtrl),
                  _field("City", cityCtrl),
                  _field("State", stateCtrl),
                  _field("Pincode", pincodeCtrl,
                      keyboard: TextInputType.number),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    title: const Text("Set as default address"),
                    value: isDefault,
                    onChanged: (val) => setState(() => isDefault = val),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : submitAddress,
                      child: isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text("Save Address"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
      String label,
      TextEditingController controller, {
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (val) => val == null || val.isEmpty
            ? "Please enter $label"
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
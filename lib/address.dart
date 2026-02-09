import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAddressPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const CreateAddressPage({super.key, required this.product});

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
  bool loadingAddresses = true;
  bool showForm = false;
  List<dynamic> addresses = [];
  String? selectedId;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    streetCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    pincodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      setState(() {
        loadingAddresses = false;
        showForm = true;
      });
      return;
    }

    try {
      final res = await http.get(
        Uri.parse('https://jewellery-backend-icja.onrender.com/api/address'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          addresses = data['addresses'] ?? [];
          showForm = addresses.isEmpty;
          if (addresses.isNotEmpty) {
            selectedId = addresses.firstWhere(
                  (a) => a['isDefault'] == true,
              orElse: () => addresses[0],
            )['_id'];
          }
        });
      }
    } catch (e) {
      setState(() => showForm = true);
    } finally {
      setState(() => loadingAddresses = false);
    }
  }

  Future<void> _submitAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final res = await http.post(
        Uri.parse('https://jewellery-backend-icja.onrender.com/api/address'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "name": nameCtrl.text.trim(),
          "phone": phoneCtrl.text.trim(),
          "street": streetCtrl.text.trim(),
          "city": cityCtrl.text.trim(),
          "state": stateCtrl.text.trim(),
          "pincode": pincodeCtrl.text.trim(),
          "isDefault": isDefault,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Address saved!"),
            backgroundColor: Color(0xFFD4AF37),
          ),
        );
        [nameCtrl, phoneCtrl, streetCtrl, cityCtrl, stateCtrl, pincodeCtrl]
            .forEach((c) => c.clear());
        await _fetchAddresses();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _proceed() {
    if (selectedId == null) return;

    final addr = addresses.firstWhere((a) => a['_id'] == selectedId);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const OrderPage(),
        settings: RouteSettings(arguments: {
          'address': addr,

          // ✅ PRODUCT DATA
          'productId': widget.product['productId'],
          'productName': widget.product['productName'],
          'price': widget.product['price'],
          'imageUrl': widget.product['imageUrl'],
          'gram': widget.product['gram'],
        }),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final mobile = w <= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: !mobile,
        title: Text(
          "Delivery Address",
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: mobile ? 18 : 22,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: loadingAddresses
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
          : showForm
          ? _buildForm(mobile)
          : _buildList(mobile),
    );
  }

  Widget _buildList(bool mobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(mobile ? 16 : 40),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Delivery Address",
                style: TextStyle(
                  fontSize: mobile ? 20 : 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              ...addresses.map((a) => _addressCard(a, mobile)),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => setState(() => showForm = true),
                icon: const Icon(Icons.add),
                label: const Text("Add New Address"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD4AF37),
                  side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: selectedId != null ? _proceed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Continue to Order", style: TextStyle(fontSize: 16)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addressCard(Map a, bool mobile) {
    final selected = selectedId == a['_id'];
    return GestureDetector(
      onTap: () => setState(() => selectedId = a['_id']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFFD4AF37) : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? const Color(0xFFD4AF37) : Colors.grey,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(a['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                      if (a['isDefault'] == true) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "Default",
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFFD4AF37),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(a['phone'], style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 4),
                  Text(
                    "${a['street']}, ${a['city']}, ${a['state']} - ${a['pincode']}",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(bool mobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(mobile ? 16 : 40),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (addresses.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => setState(() => showForm = false),
                        color: const Color(0xFFD4AF37),
                      ),
                    const Icon(Icons.location_on, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 12),
                    const Text(
                      "Add New Address",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _field("Name", nameCtrl, Icons.person_outline),
                _field("Phone", phoneCtrl, Icons.phone, TextInputType.phone),
                _field("Street", streetCtrl, Icons.home_outlined, TextInputType.text, 2),
                Row(
                  children: [
                    Expanded(child: _field("City", cityCtrl, Icons.location_city)),
                    const SizedBox(width: 12),
                    Expanded(child: _field("State", stateCtrl, Icons.map)),
                  ],
                ),
                _field("Pincode", pincodeCtrl, Icons.pin_drop, TextInputType.number),
                SwitchListTile(
                  title: const Text("Set as default"),
                  value: isDefault,
                  onChanged: (v) => setState(() => isDefault = v),
                  activeColor: const Color(0xFFD4AF37),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text("Save Address", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon,
      [TextInputType type = TextInputType.text, int lines = 1]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        maxLines: lines,
        validator: (v) {
          if (v == null || v.trim().isEmpty) return "Required";
          if (label == "Phone" && v.length != 10) return "10 digits required";
          if (label == "Pincode" && v.length != 6) return "6 digits required";
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFFD4AF37).withOpacity(0.7)),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
          ),
        ),
      ),
    );
  }
}
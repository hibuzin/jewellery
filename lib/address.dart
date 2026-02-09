import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> submitAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to add address'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await http.post(
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

      print('📍 STATUS CODE: ${response.statusCode}');
      print('📍 RESPONSE: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Address added successfully"),
            backgroundColor: const Color(0xFFD4AF37),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        Navigator.pop(context, data["address"]);
      } else {
        throw data["message"] ?? "Failed to add address";
      }
    } catch (e) {
      print('❌ ERROR: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final isMobile = screenWidth <= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: !isMobile,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey.shade800,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Delivery Address",
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          // Breadcrumb Navigation (Desktop only)
          if (isDesktop) _buildBreadcrumb(),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 40),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : 600),
                  child: isDesktop
                      ? _buildDesktopLayout()
                      : _buildMobileLayout(isMobile),
                ),
              ),
            ),
          ),

          // Sticky Bottom Bar (Desktop only)
          if (isDesktop && !isLoading) _buildStickyBottomBar(),
        ],
      ),
    );
  }

  // Breadcrumb Navigation
  Widget _buildBreadcrumb() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      color: Colors.grey.shade50,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            children: [
              _breadcrumbItem("Cart", false),
              Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
              const SizedBox(width: 8),
              _breadcrumbItem("Address", true),
              Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
              const SizedBox(width: 8),
              _breadcrumbItem("Payment", false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _breadcrumbItem(String text, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          color: isActive ? const Color(0xFFD4AF37) : Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Desktop Layout (Two Column)
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Form
        Expanded(
          flex: 3,
          child: _buildFormCard(false),
        ),

        const SizedBox(width: 40),

        // Right: Info Cards
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildAddressPreviewCard(),
              const SizedBox(height: 20),
              _buildDeliveryInfoCard(),
              const SizedBox(height: 20),
              _buildSecurityBadge(),
            ],
          ),
        ),
      ],
    );
  }

  // Mobile Layout
  Widget _buildMobileLayout(bool isMobile) {
    return Column(
      children: [
        _buildFormCard(isMobile),
        const SizedBox(height: 20),
        _buildDeliveryInfoCard(),
      ],
    );
  }

  // Form Card
  Widget _buildFormCard(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
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
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Color(0xFFD4AF37),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add New Address",
                        style: TextStyle(
                          fontSize: isMobile ? 18 : 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Enter your delivery details",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Contact Information Section
            _sectionHeader("Contact Information"),
            const SizedBox(height: 16),
            _field("Full Name", nameCtrl, Icons.person_outline),
            _field("Phone Number", phoneCtrl, Icons.phone_outlined,
                keyboard: TextInputType.phone),

            const SizedBox(height: 24),

            // Address Details Section
            _sectionHeader("Address Details"),
            const SizedBox(height: 16),
            _field("Street Address", streetCtrl, Icons.home_outlined,
                maxLines: 2),

            // City, State, Pincode in one row (Desktop)
            if (!isMobile)
              Row(
                children: [
                  Expanded(
                    child: _field("City", cityCtrl, Icons.location_city),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _field("State", stateCtrl, Icons.map_outlined),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _field("Pincode", pincodeCtrl, Icons.pin_drop_outlined,
                        keyboard: TextInputType.number),
                  ),
                ],
              )
            else ...[
              // Mobile: Separate rows
              Row(
                children: [
                  Expanded(
                    child: _field("City", cityCtrl, Icons.location_city),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _field("State", stateCtrl, Icons.map_outlined),
                  ),
                ],
              ),
              _field("Pincode", pincodeCtrl, Icons.pin_drop_outlined,
                  keyboard: TextInputType.number),
            ],

            const SizedBox(height: 24),

            // Default Address Toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDefault
                          ? const Color(0xFFD4AF37).withOpacity(0.15)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.bookmark,
                      color: isDefault
                          ? const Color(0xFFD4AF37)
                          : Colors.grey.shade400,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Default Address",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Use as my primary delivery address",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isDefault,
                    onChanged: (val) => setState(() => isDefault = val),
                    activeColor: const Color(0xFFD4AF37),
                  ),
                ],
              ),
            ),

            // Mobile: Show button here
            if (isMobile) ...[
              const SizedBox(height: 32),
              _saveButton(),
            ],
          ],
        ),
      ),
    );
  }

  // Address Preview Card
  Widget _buildAddressPreviewCard() {
    bool hasData = nameCtrl.text.isNotEmpty ||
        streetCtrl.text.isNotEmpty ||
        cityCtrl.text.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFD4AF37).withOpacity(0.1),
            const Color(0xFFD4AF37).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.preview,
                color: const Color(0xFFD4AF37),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "Address Preview",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!hasData)
            Text(
              "Your address will appear here as you type",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (nameCtrl.text.isNotEmpty)
                  Text(
                    nameCtrl.text,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (phoneCtrl.text.isNotEmpty)
                  Text(
                    phoneCtrl.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                const SizedBox(height: 8),
                if (streetCtrl.text.isNotEmpty)
                  Text(
                    streetCtrl.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                if (cityCtrl.text.isNotEmpty || stateCtrl.text.isNotEmpty)
                  Text(
                    "${cityCtrl.text}${cityCtrl.text.isNotEmpty && stateCtrl.text.isNotEmpty ? ', ' : ''}${stateCtrl.text}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                if (pincodeCtrl.text.isNotEmpty)
                  Text(
                    pincodeCtrl.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  // Delivery Info Card
  Widget _buildDeliveryInfoCard() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_shipping,
                color: const Color(0xFFD4AF37),
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                "Delivery Information",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _infoRow(Icons.check_circle, "Free delivery on orders above ₹5000"),
          _infoRow(Icons.access_time, "Delivery within 3-5 business days"),
          _infoRow(Icons.verified_user, "Secure packaging & handling"),
          _infoRow(Icons.card_giftcard, "Premium gift wrapping available"),
        ],
      ),
    );
  }

  // Security Badge
  Widget _buildSecurityBadge() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock,
            color: Colors.green.shade700,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Your information is encrypted and secure",
              style: TextStyle(
                fontSize: 13,
                color: Colors.green.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFD4AF37).withOpacity(0.7)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sticky Bottom Bar (Desktop)
  Widget _buildStickyBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: _saveButton(),
        ),
      ),
    );
  }

  // Save Button
  Widget _saveButton() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    return SizedBox(
      width: double.infinity,
      height: isMobile ? 52 : 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : submitAddress,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4AF37),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor:
          const Color(0xFFD4AF37).withOpacity(0.6),
        ),
        child: isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Save Address & Continue",
              style: TextStyle(
                fontSize: isMobile ? 16 : 17,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
        letterSpacing: 1,
      ),
    );
  }

  Widget _field(
      String label,
      TextEditingController controller,
      IconData icon, {
        TextInputType keyboard = TextInputType.text,
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        onChanged: (value) => setState(() {}), // For live preview
        validator: (val) {
          if (val == null || val.trim().isEmpty) {
            return "Please enter $label";
          }
          if (label == "Phone Number" && val.trim().length != 10) {
            return "Please enter a valid 10-digit phone number";
          }
          if (label == "Pincode" && val.trim().length != 6) {
            return "Please enter a valid 6-digit pincode";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFFD4AF37).withOpacity(0.7),
            size: 22,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFD4AF37),
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red.shade300,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:instapay_app/core/session/app_session.dart';
import 'package:instapay_app/ui/widgets/curved_header.dart';

class TelecomBillsView extends StatefulWidget {
  const TelecomBillsView({super.key});

  @override
  State<TelecomBillsView> createState() => _TelecomBillsViewState();
}

class _TelecomBillsViewState extends State<TelecomBillsView> {
  int _selectedProviderIndex = 0;
  int _selectedSubTab = 0; // 0=Mobile, 1=Internet

  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _billNameController = TextEditingController();
  bool _addToMyBills = false;
  String? _numberError;

  final List<Map<String, dynamic>> _providers = [
    {"name": "Etisalat", "color": const Color(0xFFE35205)},
    {"name": "Orange",   "color": const Color(0xFFFF7900)},
    {"name": "Vodafone", "color": const Color(0xFFE60000)},
    {"name": "WE",       "color": const Color(0xFF5C2D91)},
  ];

  @override
  void dispose() {
    _numberController.dispose();
    _billNameController.dispose();
    super.dispose();
  }

  // ─── Contact Picker (same as Send) ──────────────────────────────
  Future<void> _pickContact() async {
    final granted = await FlutterContacts.requestPermission(readonly: true);
    if (!granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contacts permission denied')),
        );
      }
      return;
    }

    final contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
    );

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final searchCtrl = TextEditingController();
        List<Contact> filtered = contacts;
        return StatefulBuilder(
          builder: (ctx2, setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.75,
              maxChildSize: 0.95,
              minChildSize: 0.4,
              builder: (_, scrollCtrl) => Column(
                children: [
                  Container(
                    width: 40, height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Choose a Contact",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEAEAEA)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.search, color: Color(0xFFAAAAAA), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: searchCtrl,
                            decoration: const InputDecoration(
                              hintText: "Search contacts...",
                              hintStyle: TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onChanged: (val) {
                              setModalState(() {
                                filtered = contacts.where((c) {
                                  final name = c.displayName.toLowerCase();
                                  final phone = c.phones.isNotEmpty ? c.phones.first.number : '';
                                  return name.contains(val.toLowerCase()) || phone.contains(val);
                                }).toList();
                              });
                            },
                          ),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: filtered.isEmpty
                      ? const Center(child: Text("No contacts found", style: TextStyle(color: Colors.grey)))
                      : ListView.separated(
                          controller: scrollCtrl,
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, indent: 68, color: Color(0xFFF0F0F0)),
                          itemBuilder: (_, i) {
                            final contact = filtered[i];
                            final name = contact.displayName;
                            final phone = contact.phones.isNotEmpty ? contact.phones.first.number : '';
                            final cleaned = _formatPhone(phone);
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                              leading: CircleAvatar(
                                radius: 22,
                                backgroundColor: const Color(0xFF7B2FF7).withOpacity(0.12),
                                backgroundImage: contact.photo != null && contact.photo!.isNotEmpty
                                    ? MemoryImage(contact.photo!) : null,
                                child: (contact.photo == null || contact.photo!.isEmpty)
                                    ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                                        style: const TextStyle(color: Color(0xFF7B2FF7), fontWeight: FontWeight.w700, fontSize: 16))
                                    : null,
                              ),
                              title: Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                              subtitle: phone.isNotEmpty ? Text(phone, style: const TextStyle(fontSize: 12, color: Color(0xFF888888))) : null,
                              onTap: () {
                                _numberController.text = cleaned;
                                setState(() => _numberError = null);
                                Navigator.pop(ctx2);
                              },
                            );
                          },
                        ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatPhone(String number) {
    number = number.replaceAll(RegExp(r'[^0-9+]'), '');
    if (number.startsWith('+20')) number = '0' + number.substring(3);
    else if (number.startsWith('20') && number.length > 10) number = '0' + number.substring(2);
    return number;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return _selectedSubTab == 0 ? 'Mobile number is required' : 'Landline number is required';
    }
    if (_selectedSubTab == 0) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (!RegExp(r'^(010|011|012|015)\d{8}$').hasMatch(cleaned)) {
        return 'Enter a valid Egyptian number (01x xxxxxxxx)';
      }
    } else {
      final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleaned.length < 7) return 'Enter a valid landline number';
    }
    return null;
  }

  void _onNextPressed() {
    final numErr = _validateNumber(_numberController.text);
    setState(() => _numberError = numErr);
    if (numErr != null) return;

    if (_addToMyBills) {
      if (_billNameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a bill name")),
        );
        return;
      }
      final session = context.read<AppSession>();
      session.addBill(
        _billNameController.text,
        _numberController.text,
        _providers[_selectedProviderIndex]['name'],
        _selectedSubTab == 0 ? "Mobile" : "Internet",
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bill saved to My Bills")),
      );
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CurvedHeader(title: "Bill Payment"),
            const SizedBox(height: 24),

            // Top Category Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFF8C42)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text("Telecom & Internet Bills",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFFFF8C42), fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F8FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text("Telecom & Internet...",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF5A6B87), fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Provider Icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_providers.length, (index) {
                  final isSelected = _selectedProviderIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedProviderIndex = index),
                    child: Column(
                      children: [
                        Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? const Color(0xFFFF8C42) : const Color(0xFFF0F0F0),
                              width: 1.5,
                            ),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))],
                          ),
                          child: Center(child: _buildProviderLogo(index)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _providers[index]['name'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.black : Colors.grey,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 32),

            // Sub-tabs: Mobile / Internet
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildSubTab(0, "Mobile"),
                  const SizedBox(width: 12),
                  _buildSubTab(1, "Internet"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Input field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _numberError != null ? Colors.red : const Color(0xFFF0F2F5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _numberController,
                            keyboardType: TextInputType.phone,
                            onChanged: (_) => setState(() => _numberError = null),
                            decoration: InputDecoration(
                              hintText: _selectedSubTab == 0
                                  ? "* Please enter mobile number"
                                  : "* Please enter landline number",
                              hintStyle: const TextStyle(color: Color(0xFFBDC4CD), fontSize: 13),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _selectedSubTab == 0 ? _pickContact : null,
                          child: Icon(
                            Icons.person_outline,
                            color: _selectedSubTab == 0 ? const Color(0xFF7B2FF7) : const Color(0xFFBDC4CD),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_numberError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4),
                      child: Text(_numberError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Add to my bills checkbox
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _addToMyBills = !_addToMyBills),
                        child: Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(
                            color: _addToMyBills ? const Color(0xFFFF8C42) : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: _addToMyBills ? const Color(0xFFFF8C42) : const Color(0xFFD1D5DB)),
                          ),
                          child: _addToMyBills ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text("Add to my bills", style: TextStyle(color: Color(0xFF4B5563), fontSize: 14)),
                    ],
                  ),
                  if (_addToMyBills) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF0F2F5)),
                      ),
                      child: TextField(
                        controller: _billNameController,
                        decoration: const InputDecoration(
                          hintText: "Bill Name",
                          hintStyle: TextStyle(color: Color(0xFFBDC4CD), fontSize: 13),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B2FF7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text("Next", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTab(int index, String label) {
    final isSelected = _selectedSubTab == index;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedSubTab = index;
        _numberController.clear();
        _numberError = null;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFFFF8C42) : const Color(0xFFF0F2F5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFFFF8C42) : const Color(0xFF5A6B87),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProviderLogo(int index) {
    final name = _providers[index]['name'];
    if (name == "Etisalat") {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("e&", style: TextStyle(color: Color(0xFFE35205), fontWeight: FontWeight.w900, fontSize: 18)),
          Text("etisalat and", style: TextStyle(color: Color(0xFFE35205), fontSize: 6)),
        ],
      );
    } else if (name == "Orange") {
      return Container(width: 32, height: 32, color: const Color(0xFFFF7900));
    } else if (name == "Vodafone") {
      return const Icon(Icons.emergency, color: Color(0xFFE60000), size: 32);
    } else {
      return const Text("we", style: TextStyle(color: Color(0xFF5C2D91), fontWeight: FontWeight.bold, fontSize: 20));
    }
  }
}

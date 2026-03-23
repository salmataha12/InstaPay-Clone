import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'send_viewmodel.dart';

class SendView extends StatefulWidget {
  const SendView({super.key});

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  final viewModel = SendViewModel();

  final List<IconData> icons = [
    Icons.phone_iphone,
    Icons.alternate_email,
    Icons.account_balance,
    Icons.credit_card,
    Icons.account_balance_wallet,
  ];

  final List<String> tabLabels = [
    'Mobile',
    'IPA',
    'Bank',
    'Card',
    'Wallet',
  ];

  int _currentPage = 0;

  // ── Text controllers for fields that receive contact data ──────
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _walletController = TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    _walletController.dispose();
    super.dispose();
  }

  // ── Contact picker ─────────────────────────────────────────────
  Future<void> _pickContact(TextEditingController controller) async {
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
      builder: (context) {
        final searchController = TextEditingController();
        List<Contact> filtered = contacts;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.75,
              maxChildSize: 0.95,
              minChildSize: 0.4,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    // Handle
                    Container(
                      width: 40, height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Choose a Contact",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Search bar
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
                          const Icon(Icons.search,
                              color: Color(0xFFAAAAAA), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                hintText: "Search contacts...",
                                hintStyle: TextStyle(
                                    color: Color(0xFFBBBBBB), fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (val) {
                                setModalState(() {
                                  filtered = contacts.where((c) {
                                    final name = c.displayName.toLowerCase();
                                    final phone = c.phones.isNotEmpty
                                        ? c.phones.first.number
                                        : '';
                                    return name.contains(val.toLowerCase()) ||
                                        phone.contains(val);
                                  }).toList();
                                });
                              },
                            ),
                          ),
                        ]),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Contact list
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(
                              child: Text("No contacts found",
                                  style: TextStyle(color: Colors.grey)))
                          : ListView.separated(
                              controller: scrollController,
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => const Divider(
                                  height: 1,
                                  indent: 68,
                                  color: Color(0xFFF0F0F0)),
                              itemBuilder: (context, i) {
                                final contact = filtered[i];
                                final name = contact.displayName;
                                final phone = contact.phones.isNotEmpty
                                    ? contact.phones.first.number
                                    : '';
                                final cleanPhone = phone
                                    .replaceAll(' ', '')
                                    .replaceAll('-', '')
                                    .replaceAll('(', '')
                                    .replaceAll(')', '');

                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 4),
                                  leading: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: const Color(0xFF7B2FF7)
                                        .withOpacity(0.12),
                                    backgroundImage: contact.photo != null &&
                                            contact.photo!.isNotEmpty
                                        ? MemoryImage(contact.photo!)
                                        : null,
                                    child: (contact.photo == null ||
                                            contact.photo!.isEmpty)
                                        ? Text(
                                            name.isNotEmpty
                                                ? name[0].toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                              color: Color(0xFF7B2FF7),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            ),
                                          )
                                        : null,
                                  ),
                                  title: Text(name,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1A1A1A))),
                                  subtitle: phone.isNotEmpty
                                      ? Text(phone,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF888888)))
                                      : null,
                                  onTap: () {
                                    controller.text = cleanPhone;
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildFromCard(),
                  const SizedBox(height: 12),
                  _buildSendCard(),
                  const SizedBox(height: 14),
                  _buildAddReason(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildNextButton(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 130,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 130,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF7B2FF7),
                  Color(0xFF9B59F5),
                  Color(0xFFB06EF8),
                ],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
          ),
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.75),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: 40,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFF8C42).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Text(
              "Send Money",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // FROM CARD
  // ═══════════════════════════════════════════════════════════════
  Widget _buildFromCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1B7A3E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.account_balance,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("From",
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400)),
                  SizedBox(height: 3),
                  Text(
                    "hanan_elsayed2710@instapay",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text("SAVING",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          letterSpacing: 0.5)),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.grey, size: 22),
          ],
        ),
      ),
    );
  }

  int _bankSubTab = 0;

  // ═══════════════════════════════════════════════════════════════
  // MAIN SEND CARD — swipeable two pages, no fixed height
  // ═══════════════════════════════════════════════════════════════
  Widget _buildSendCard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 60;
    final itemWidth = cardWidth / 5;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (details) {
          final v = details.primaryVelocity ?? 0;
          if (v < -100 && _currentPage == 0) {
            setState(() => _currentPage = 1);
          } else if (v > 100 && _currentPage == 1) {
            setState(() => _currentPage = 0);
          }
        },
        child: Container(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _currentPage == 0 ? "Send Money To" : "Send Money To My Accounts",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1A1A1A)),
                ),
                if (_currentPage == 0)
                  Row(children: const [
                    Icon(Icons.star_border_rounded,
                        size: 16, color: Color(0xFFFF8C42)),
                    SizedBox(width: 4),
                    Text("Favorites",
                        style: TextStyle(
                            color: Color(0xFFFF8C42),
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                    SizedBox(width: 2),
                    Icon(Icons.chevron_right,
                        size: 16, color: Color(0xFFFF8C42)),
                  ]),
              ],
            ),

            const SizedBox(height: 16),

            // PageView for swipe between pages
            // Use IndexedStack so height adjusts to content naturally
            _currentPage == 0
                ? _buildPageOne(itemWidth)
                : _buildMyAccountsPage(),

            const SizedBox(height: 16),

            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (i) => GestureDetector(
                  onTap: () => setState(() => _currentPage = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _currentPage
                          ? const Color(0xFFFF8C42)
                          : const Color(0xFFCCCCCC),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── PAGE 1: Tabs + content ────────────────────────────────────
  Widget _buildPageOne(double itemWidth) {
    return Column(
      children: [
        // Tab icons
        Row(
          children: List.generate(5, (index) {
            final isSelected = index == viewModel.selectedTab;
            return SizedBox(
              width: itemWidth,
              child: GestureDetector(
                onTap: () => setState(() {
                  viewModel.selectTab(index);
                  _bankSubTab = 0;
                }),
                child: Column(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF7B2FF7)
                          : const Color(0xFFF1F1F1),
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF7B2FF7).withOpacity(0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    child: Icon(icons[index],
                        size: 21,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF888888)),
                  ),
                ]),
              ),
            );
          }),
        ),

        const SizedBox(height: 6),

        // Animated underline
        Stack(children: [
          Container(height: 3, color: const Color(0xFFF0F0F0)),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            left: itemWidth * viewModel.selectedTab + (itemWidth - 28) / 2,
            top: 0,
            child: Container(
              width: 28,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFF7B2FF7),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ]),

        const SizedBox(height: 16),

        // Tab content
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: KeyedSubtree(
            key: ValueKey(viewModel.selectedTab),
            child: _buildTabContent(viewModel.selectedTab),
          ),
        ),
      ],
    );
  }

  // ── PAGE 2: Send To My Accounts ───────────────────────────────
  Widget _buildMyAccountsPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            const Text(
              "Please add additional bank accounts on InstaPay\nto use this service",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF888888),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF8C42),
                side: const BorderSide(color: Color(0xFFFF8C42), width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              child: const Text(
                "Add Bank Account",
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // TAB CONTENT ROUTER
  // ═══════════════════════════════════════════════════════════════
  Widget _buildTabContent(int tab) {
    switch (tab) {
      case 0: return _buildMobileContent();
      case 1: return _buildIpaContent();
      case 2: return _buildBankContent();
      case 3: return _buildCardContent();
      case 4: return _buildWalletContent();
      default: return _buildMobileContent();
    }
  }

  // ── Shared helpers ────────────────────────────────────────────
  Widget _tabLabel(String text, {bool showHelp = true}) {
    return Row(children: [
      Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xFF7B2FF7))),
      const Spacer(),
      if (showHelp)
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
              color: Color(0xFFEEEEEE), shape: BoxShape.circle),
          child: const Icon(Icons.question_mark_rounded,
              size: 13, color: Colors.grey),
        ),
    ]);
  }

  Widget _inputBox({
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
    Widget? prefix,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Row(children: [
        if (prefix != null) ...[prefix, const SizedBox(width: 8)],
        Expanded(
          child: TextField(
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
        if (suffix != null) suffix,
      ]),
    );
  }

  /// Same as _inputBox but with a TextEditingController (for contact picker)
  Widget _inputBoxWithController({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
    Widget? prefix,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Row(children: [
        if (prefix != null) ...[prefix, const SizedBox(width: 8)],
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
        if (suffix != null) suffix,
      ]),
    );
  }

  Widget _amountInput() => _inputBox(
        hint: "Amount",
        keyboardType: TextInputType.number,
        suffix: const Text("EGP",
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF888888))),
      );

  // ── TAB 0 — Mobile ───────────────────────────────────────────
  Widget _buildMobileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tabLabel("Mobile Number"),
        const SizedBox(height: 10),
        _inputBoxWithController(
          controller: _mobileController,
          hint: "Mobile Number",
          keyboardType: TextInputType.phone,
          suffix: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.assignment_outlined,
                size: 20, color: Colors.orange.shade400),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _pickContact(_mobileController),
              child: const Icon(Icons.person_outline_rounded,
                  size: 20, color: Color(0xFFAAAAAA)),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        _amountInput(),
      ],
    );
  }

  // ── TAB 1 — IPA ───────────────────────────────────────────────
  Widget _buildIpaContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tabLabel("Payment Address", showHelp: false),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ipaActionIcon(Icons.link_rounded),
            _ipaActionIcon(Icons.qr_code_2_rounded),
            _ipaActionIcon(Icons.star_border_rounded),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "To send money using a payment address, use the "
          "beneficiary's payment link, scan their QR code, or "
          "choose from favorites.",
          style: TextStyle(
              fontSize: 12, color: Color(0xFF888888), height: 1.6),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _ipaActionIcon(IconData icon) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, size: 24, color: const Color(0xFF666666)),
    );
  }

  // ── TAB 2 — Bank ──────────────────────────────────────────────
  Widget _buildBankContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tabLabel("Bank Account", showHelp: false),
        const SizedBox(height: 12),
        Row(children: [
          _bankSubTabBtn("Account NO.", 0),
          const SizedBox(width: 24),
          _bankSubTabBtn("IBAN NO.", 1),
        ]),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: KeyedSubtree(
            key: ValueKey(_bankSubTab),
            child: _bankSubTab == 0
                ? _buildBankAccountContent()
                : _buildIbanContent(),
          ),
        ),
      ],
    );
  }

  Widget _bankSubTabBtn(String label, int index) {
    final active = _bankSubTab == index;
    return GestureDetector(
      onTap: () => setState(() => _bankSubTab = index),
      child: Column(children: [
        Text(label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              color: active
                  ? const Color(0xFFFF8C42)
                  : const Color(0xFF888888),
            )),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 2,
          width: active ? label.length * 7.5 : 0,
          decoration: BoxDecoration(
            color: const Color(0xFFFF8C42),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ]),
    );
  }

  Widget _buildBankAccountContent() {
    return Column(children: [
      Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEAEAEA)),
        ),
        child: Row(children: const [
          Expanded(
            child: Text("Select Bank",
                style:
                    TextStyle(color: Color(0xFFBBBBBB), fontSize: 13)),
          ),
          Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.grey, size: 20),
        ]),
      ),
      const SizedBox(height: 10),
      _inputBox(
        hint: "Account Number",
        keyboardType: TextInputType.number,
        suffix: Icon(Icons.assignment_outlined,
            size: 20, color: Colors.orange.shade400),
      ),
      const SizedBox(height: 10),
      _inputBox(hint: "Receiver name"),
      const SizedBox(height: 10),
      _amountInput(),
    ]);
  }

  Widget _buildIbanContent() {
    return Column(children: [
      _inputBox(
        hint: "IBAN no.",
        keyboardType: TextInputType.text,
        prefix: const Text("EG",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
                fontSize: 14)),
        suffix: Icon(Icons.assignment_outlined,
            size: 20, color: Colors.orange.shade400),
      ),
      const SizedBox(height: 10),
      _inputBox(hint: "Receiver name"),
      const SizedBox(height: 10),
      _amountInput(),
    ]);
  }

  // ── TAB 3 — Card (UPDATED) ────────────────────────────────────
  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tabLabel("Card Number"),
        const SizedBox(height: 10),
        _inputBox(
          hint: "Card Number",
          keyboardType: TextInputType.number,
          suffix: Icon(Icons.assignment_outlined,
              size: 20, color: Colors.orange.shade400),
        ),
        const SizedBox(height: 10),
        // Added Card Holder Name field
        _inputBox(hint: "Card Holder Name"),
        const SizedBox(height: 10),
        _amountInput(),
      ],
    );
  }

  // ── TAB 4 — Wallet (UPDATED) ──────────────────────────────────
  Widget _buildWalletContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tabLabel("Wallet Number"),
        const SizedBox(height: 10),
        _inputBoxWithController(
          controller: _walletController,
          hint: "Mobile Number",
          keyboardType: TextInputType.phone,
          suffix: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.assignment_outlined,
                size: 20, color: Colors.orange.shade400),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _pickContact(_walletController),
              child: const Icon(Icons.person_outline_rounded,
                  size: 20, color: Color(0xFFAAAAAA)),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        _amountInput(),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ADD REASON — tapping shows bottom sheet
  // ═══════════════════════════════════════════════════════════════
  Widget _buildAddReason() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: _showReasonBottomSheet,
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.orange.shade400, width: 1.5),
              ),
              child:
                  Icon(Icons.add, size: 14, color: Colors.orange.shade400),
            ),
            const SizedBox(width: 8),
            Text(
              "Add Reason for Transfer",
              style: TextStyle(
                color: Colors.orange.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Reason Bottom Sheet ───────────────────────────────────────
  String _selectedReason = "Living Expenses";
  final List<String> _reasons = [
    "Living Expenses",
    "Family Support",
    "Rent",
    "Medical",
    "Education",
    "Business",
    "Other",
  ];

  void _showReasonBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        String tempReason = _selectedReason;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const Text(
                    "Reason for transfer",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A)),
                  ),

                  const SizedBox(height: 16),

                  // Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: tempReason,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: Colors.grey),
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF1A1A1A)),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => tempReason = val);
                          }
                        },
                        items: _reasons
                            .map((r) => DropdownMenuItem(
                                  value: r,
                                  child: Text(r),
                                ))
                            .toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Notes field
                  Container(
                    height: 100,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                    ),
                    child: const TextField(
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: "Notes",
                        hintStyle: TextStyle(
                            color: Color(0xFFBBBBBB), fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _selectedReason = tempReason);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B2FF7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
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

  // ═══════════════════════════════════════════════════════════════
  // NEXT BUTTON
  // ═══════════════════════════════════════════════════════════════
  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 52,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7B2FF7), Color(0xFF9B59F5)],
            ),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B2FF7).withOpacity(0.4),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "Next",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

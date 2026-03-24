import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/security/security_utils.dart';
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

  final List<String> tabLabels = ['Mobile', 'IPA', 'Bank', 'Card', 'Wallet'];

  int _currentPage = 0;

  // ── Text controllers ───────────────────────────────────────────
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _walletController = TextEditingController();

  // ── FIX 2 & 3: Amount controllers per tab ────────────────────
  final TextEditingController _mobileAmountController = TextEditingController();
  final TextEditingController _walletAmountController = TextEditingController();
  final TextEditingController _bankAmountController = TextEditingController();
  final TextEditingController _cardAmountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _pickedContactName;

  // ── FIX 2 & 3: Validation error state ────────────────────────
  String? _mobileError;
  String? _mobileAmountError;
  String? _walletError;
  String? _walletAmountError;
  String? _bankAmountError;
  String? _cardAmountError;

  @override
  void dispose() {
    _mobileController.dispose();
    _walletController.dispose();
    _mobileAmountController.dispose();
    _walletAmountController.dispose();
    _bankAmountController.dispose();
    _cardAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

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
                      width: 40,
                      height: 4,
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
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: Color(0xFFAAAAAA),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                decoration: const InputDecoration(
                                  hintText: "Search contacts...",
                                  hintStyle: TextStyle(
                                    color: Color(0xFFBBBBBB),
                                    fontSize: 13,
                                  ),
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
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Contact list
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(
                              child: Text(
                                "No contacts found",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.separated(
                              controller: scrollController,
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 1,
                                indent: 68,
                                color: Color(0xFFF0F0F0),
                              ),
                              itemBuilder: (context, i) {
                                final contact = filtered[i];
                                final name = contact.displayName;
                                final phone = contact.phones.isNotEmpty
                                    ? contact.phones.first.number
                                    : '';

                                // FIX 4: Format number on contact pick
                                final cleanPhone = _formatEgyptianNumber(phone);

                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 4,
                                  ),
                                  leading: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: const Color(
                                      0xFF7B2FF7,
                                    ).withOpacity(0.12),
                                    backgroundImage:
                                        contact.photo != null &&
                                            contact.photo!.isNotEmpty
                                        ? MemoryImage(contact.photo!)
                                        : null,
                                    child:
                                        (contact.photo == null ||
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
                                  title: Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  subtitle: phone.isNotEmpty
                                      ? Text(
                                          phone,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF888888),
                                          ),
                                        )
                                      : null,
                                  onTap: () {
                                    // FIX 4: store formatted number
                                    controller.text = cleanPhone;
                                    Navigator.pop(context);
                                    // Clear error on pick
                                    setState(() {
                                      if (controller == _mobileController) {
                                        _mobileError = null;
                                        _pickedContactName =
                                            name; // <-- store name
                                      } else if (controller ==
                                          _walletController) {
                                        _walletError = null;
                                        _pickedContactName =
                                            name; // <-- store name
                                      }
                                    });
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

  String _formatEgyptianNumber(String number) {
    number = number.replaceAll(RegExp(r'[^0-9+]'), '');

    if (number.startsWith('+20')) {
      number = '0' + number.substring(3);
    } else if (number.startsWith('20') && number.length > 10) {
      number = '0' + number.substring(2);
    }

    return number;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (!RegExp(r'^(010|011|012|015)\d{8}$').hasMatch(cleaned)) {
      return 'Enter a valid Egyptian number (01x xxxxxxxx)';
    }
    return null;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount is required';
    final amount = double.tryParse(value);
    if (amount == null) return 'Enter a valid number';
    if (amount <= 0) return 'Amount must be greater than zero';
    if (amount > 100000) return 'Exceeds max limit (100,000 EGP)';
    return null;
  }

  // ── Validate active tab then navigate ────────────────────────
  void _onNextPressed() {
    bool valid = true;

    switch (viewModel.selectedTab) {
      case 0: // Mobile
        final mErr = _validateMobile(_mobileController.text);
        final aErr = _validateAmount(_mobileAmountController.text);
        setState(() {
          _mobileError = mErr;
          _mobileAmountError = aErr;
        });
        valid = mErr == null && aErr == null;
        break;

      case 4: // Wallet
        final wErr = _validateMobile(_walletController.text);
        final aErr = _validateAmount(_walletAmountController.text);
        setState(() {
          _walletError = wErr;
          _walletAmountError = aErr;
        });
        valid = wErr == null && aErr == null;
        break;

      case 2: // Bank
        final aErr = _validateAmount(_bankAmountController.text);
        setState(() => _bankAmountError = aErr);
        valid = aErr == null;
        break;

      case 3: // Card
        final aErr = _validateAmount(_cardAmountController.text);
        setState(() => _cardAmountError = aErr);
        valid = aErr == null;
        break;
    }

    if (!valid) return;

    // FIX 4: format and sanitize before passing forward
    final typeMap = {0: 'Mobile', 1: 'IPA', 2: 'Bank', 3: 'Card', 4: 'Wallet'};
    final accountType = SecurityUtils.sanitizeInput(
      typeMap[viewModel.selectedTab] ?? 'Unknown',
    );
    String recipient = '';
    String amount = '';

    switch (viewModel.selectedTab) {
      case 0:
        recipient = _formatEgyptianNumber(_mobileController.text);
        amount = _mobileAmountController.text;
        break;
      case 4:
        recipient = _formatEgyptianNumber(_walletController.text);
        amount = _walletAmountController.text;
        break;
      case 2:
        recipient = "Bank Account Details (Hidden)";
        amount = _bankAmountController.text;
        break;
      case 3:
        recipient = "Card Details (Hidden)";
        amount = _cardAmountController.text;
        break;
    }

    // Additional numeric safety check
    if (!SecurityUtils.isValidAmount(amount)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid amount detected')));
      return;
    }

    // Push the confirmation route
    context.push(
      '/send_confirmation',
      extra: {
        'type': accountType,
        'recipient': SecurityUtils.sanitizeInput(recipient),
        'recipientName': SecurityUtils.sanitizeInput(
          _pickedContactName ?? 'InstaPay User',
        ),
        'amount': SecurityUtils.sanitizeInput(amount),
        'reason': SecurityUtils.sanitizeInput(_selectedReason),
        'notes': SecurityUtils.sanitizeInput(_notesController.text),
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════
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
              child: const Icon(
                Icons.account_balance,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "From",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "salmataha12@instapay",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    "SAVING",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  int _bankSubTab = 0;

  // MAIN SEND CARD — unchanged UI, swipe intact

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _currentPage == 0
                        ? "Send Money To"
                        : "Send Money To My Accounts",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  if (_currentPage == 0)
                    Row(
                      children: const [
                        Icon(
                          Icons.star_border_rounded,
                          size: 16,
                          color: Color(0xFFFF8C42),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Favorites",
                          style: TextStyle(
                            color: Color(0xFFFF8C42),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: Color(0xFFFF8C42),
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 16),

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
      ),
    );
  }

  // ── PAGE 1 — unchanged UI ─────────────────────────────────────
  Widget _buildPageOne(double itemWidth) {
    return Column(
      children: [
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
                child: Column(
                  children: [
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
                                  color: const Color(
                                    0xFF7B2FF7,
                                  ).withOpacity(0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        icons[index],
                        size: 21,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 6),

        Stack(
          children: [
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
          ],
        ),

        const SizedBox(height: 16),

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

  // ── PAGE 2 — unchanged
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
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
              ),
              child: const Text(
                "Add Bank Account",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(int tab) {
    switch (tab) {
      case 0:
        return _buildMobileContent();
      case 1:
        return _buildIpaContent();
      case 2:
        return _buildBankContent();
      case 3:
        return _buildCardContent();
      case 4:
        return _buildWalletContent();
      default:
        return _buildMobileContent();
    }
  }

  Widget _tabLabel(String text, {bool showHelp = true}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Color(0xFF7B2FF7),
          ),
        ),
        const Spacer(),
        if (showHelp)
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFFEEEEEE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.question_mark_rounded,
              size: 13,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }

  Widget _inputBox({
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
    Widget? prefix,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Row(
        children: [
          if (prefix != null) ...[prefix, const SizedBox(width: 8)],
          Expanded(
            child: TextField(
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFFBBBBBB),
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }

  /// Input box WITH controller + optional validation display
  Widget _inputBoxWithController({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
    Widget? prefix,
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            // FIX 2: red tint when error
            color: errorText != null
                ? const Color(0xFFFFEEEE)
                : const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null
                  ? Colors.red.shade300
                  : const Color(0xFFEAEAEA),
            ),
          ),
          child: Row(
            children: [
              if (prefix != null) ...[prefix, const SizedBox(width: 8)],
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A1A),
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: Color(0xFFBBBBBB),
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              if (suffix != null) suffix,
            ],
          ),
        ),
        // FIX 2: show error below field
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          ),
      ],
    );
  }

  Widget _amountInputControlled({
    required TextEditingController controller,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            // FIX 3: red tint when error
            color: errorText != null
                ? const Color(0xFFFFEEEE)
                : const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null
                  ? Colors.red.shade300
                  : const Color(0xFFEAEAEA),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  // FIX 3: numeric keyboard, no minus sign
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A1A),
                  ),
                  decoration: const InputDecoration(
                    hintText: "Amount",
                    hintStyle: TextStyle(
                      color: Color(0xFFBBBBBB),
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              const Text(
                "EGP",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF888888),
                ),
              ),
            ],
          ),
        ),
        // FIX 3: show error below amount
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          ),
      ],
    );
  }

  Widget _buildMobileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tabLabel("Mobile Number"),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child:
                  _pickedContactName != null &&
                      _mobileController.text.isNotEmpty
                  ? Container(
                      height: 54,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBEBEB),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _pickedContactName!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF666666),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _mobileController.text,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1A1A1A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _pickedContactName = null;
                                _mobileController.clear();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFFF8C42),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Color(0xFFFF8C42),
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : _inputBoxWithController(
                      controller: _mobileController,
                      hint: "Mobile Number",
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                      ],
                      errorText: _mobileError,
                      onChanged: (val) {
                        setState(() {
                          _mobileError = null;
                          if (val.isEmpty) _pickedContactName = null;
                        });
                      },
                    ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _pickContact(_mobileController),
              child: Container(
                height: 48, // matching inputBox height
                width: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEAEAEA)),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _amountInputControlled(
          controller: _mobileAmountController,
          errorText: _mobileAmountError,
          onChanged: (_) => setState(() => _mobileAmountError = null),
        ),
      ],
    );
  }

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
          style: TextStyle(fontSize: 12, color: Color(0xFF888888), height: 1.6),
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

  Widget _buildBankContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tabLabel("Bank Account", showHelp: false),
        const SizedBox(height: 12),
        Row(
          children: [
            _bankSubTabBtn("Account NO.", 0),
            const SizedBox(width: 24),
            _bankSubTabBtn("IBAN NO.", 1),
          ],
        ),
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
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              color: active ? const Color(0xFFFF8C42) : const Color(0xFF888888),
            ),
          ),
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
        ],
      ),
    );
  }

  Widget _buildBankAccountContent() {
    return Column(
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEAEAEA)),
          ),
          child: Row(
            children: const [
              Expanded(
                child: Text(
                  "Select Bank",
                  style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // FIX 2: digits only for account number
        _inputBox(
          hint: "Account Number",
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffix: Icon(
            Icons.assignment_outlined,
            size: 20,
            color: Colors.orange.shade400,
          ),
        ),
        const SizedBox(height: 10),
        _inputBox(hint: "Receiver name"),
        const SizedBox(height: 10),
        // FIX 3: validated amount
        _amountInputControlled(
          controller: _bankAmountController,
          errorText: _bankAmountError,
          onChanged: (_) => setState(() => _bankAmountError = null),
        ),
      ],
    );
  }

  Widget _buildIbanContent() {
    return Column(
      children: [
        _inputBox(
          hint: "IBAN no.",
          keyboardType: TextInputType.text,
          prefix: const Text(
            "EG",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
              fontSize: 14,
            ),
          ),
          suffix: Icon(
            Icons.assignment_outlined,
            size: 20,
            color: Colors.orange.shade400,
          ),
        ),
        const SizedBox(height: 10),
        _inputBox(hint: "Receiver name"),
        const SizedBox(height: 10),
        // FIX 3: validated amount
        _amountInputControlled(
          controller: _bankAmountController,
          errorText: _bankAmountError,
          onChanged: (_) => setState(() => _bankAmountError = null),
        ),
      ],
    );
  }

  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tabLabel("Card Number"),
        const SizedBox(height: 10),
        // FIX 2: digits only, max 16
        _inputBox(
          hint: "Card Number",
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
          ],
          suffix: Icon(
            Icons.assignment_outlined,
            size: 20,
            color: Colors.orange.shade400,
          ),
        ),
        const SizedBox(height: 10),
        _inputBox(hint: "Card Holder Name"),
        const SizedBox(height: 10),
        // FIX 3: validated amount
        _amountInputControlled(
          controller: _cardAmountController,
          errorText: _cardAmountError,
          onChanged: (_) => setState(() => _cardAmountError = null),
        ),
      ],
    );
  }

  Widget _buildWalletContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tabLabel("Wallet Number"),
        const SizedBox(height: 10),
        // FIX 2: wallet number validation
        _inputBoxWithController(
          controller: _walletController,
          hint: "Mobile Number",
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
          ],
          errorText: _walletError,
          onChanged: (_) => setState(() => _walletError = null),
          suffix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 20,
                color: Colors.orange.shade400,
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _pickContact(_walletController),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 20,
                  color: Color(0xFFAAAAAA),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // FIX 3: validated amount
        _amountInputControlled(
          controller: _walletAmountController,
          errorText: _walletAmountError,
          onChanged: (_) => setState(() => _walletAmountError = null),
        ),
      ],
    );
  }

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
                border: Border.all(color: Colors.orange.shade400, width: 1.5),
              ),
              child: Icon(Icons.add, size: 14, color: Colors.orange.shade400),
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
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                        ),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => tempReason = val);
                          }
                        },
                        items: _reasons
                            .map(
                              (r) => DropdownMenuItem(value: r, child: Text(r)),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 100,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                    ),
                    child: TextField(
                      controller: _notesController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        hintText: "Notes",
                        hintStyle: TextStyle(
                          color: Color(0xFFBBBBBB),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
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

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: GestureDetector(
        onTap: _onNextPressed, // FIX 2 & 3: triggers validation
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/views/onboarding/onboarding_view.dart';
import 'ui/views/auth/signup_view.dart';
import 'ui/views/auth/otp_view.dart';
import 'ui/views/auth/create_account_view.dart';
import 'package:instapay_app/ui/views/auth/biometric_view.dart';
import 'ui/views/auth/bank_selection_view.dart';
import 'ui/views/auth/card_link_view.dart';

import 'ui/views/home/home_view.dart';
import 'ui/views/more/more_view.dart';
import 'ui/views/Bills/bills_view.dart';
import 'ui/views/send/send_view.dart';
import 'ui/views/send/send_confirmation_view.dart';
import 'ui/views/send/pin_entry_view.dart';
import 'ui/views/send/transfer_success_view.dart';
import 'ui/views/collect/collect_view.dart';
import 'ui/views/Bills/telecom_bills_view.dart';
import 'ui/views/transactions/transactions_view.dart';

import 'ui/widgets/main_navigation.dart';

class InstaPayApp extends StatelessWidget {
  const InstaPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/onboarding',

      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (_, __) => const OnboardingView(),
        ),
        GoRoute(path: '/signup', builder: (_, __) => const SignUpView()),
        GoRoute(path: '/otp', builder: (_, __) => const OtpView()),
        GoRoute(
          path: '/create-account',
          builder: (_, __) => const CreateAccountView(),
        ),
        GoRoute(
          path: '/biometric',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>?;
            return BiometricView(
              nextRoute: data?['nextRoute'] as String?,
              nextData: data?['nextData'] as Map<String, dynamic>?,
            );
          },
        ),
        GoRoute(path: '/bank', builder: (_, __) => const BankSelectionView()),
        GoRoute(path: '/card', builder: (_, __) => const CardLinkView()),

        ShellRoute(
          builder: (context, state, child) {
            return MainNavigation(child: child);
          },
          routes: [
            /// HOME
            GoRoute(path: '/home', builder: (_, __) => const HomeView()),

            GoRoute(path: '/send', builder: (_, __) => const SendView()),

            /// RECEIVE
            GoRoute(path: '/collect', builder: (_, __) => const CollectView()),

            /// BILLS
            GoRoute(path: '/bills', builder: (_, __) => const BillsView()),

            GoRoute(
              path: '/telecom_bills',
              builder: (_, __) => const TelecomBillsView(),
            ),

            /// MORE
            GoRoute(path: '/more', builder: (_, __) => const MoreView()),
          ],
        ),
        GoRoute(
          path: '/send_confirmation',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>? ?? {};
            return SendConfirmationView(transferData: data);
          },
        ),
        GoRoute(
          path: '/pin_entry',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>? ?? {};
            return PinEntryView(transferData: data);
          },
        ),
        GoRoute(
          path: '/transfer_success',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>? ?? {};
            return TransferSuccessView(transferData: data);
          },
        ),
        GoRoute(
          path: '/transactions',
          builder: (_, __) => const TransactionsView(),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'InstaPay',
      routerConfig: router,
      theme: ThemeData(fontFamily: 'Poppins'),
    );
  }
}

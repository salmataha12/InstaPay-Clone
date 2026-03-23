class OnboardingItem {
  final String title;
  final String description;
  final String image;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });
}

class OnboardingViewModel {
  final List<OnboardingItem> pages = [
    OnboardingItem(
      title: "Welcome to InstaPay",
      description:
          "With InstaPay you can send and receive money, pay your bills or purchase from merchants instantly 24x7.",
      image: "assets/images/onboarding1.png",
    ),
    OnboardingItem(
      title: "Send Money",
      description:
          "Send Money instantly from your bank accounts and Meeza Prepaid Cards. Your transactions are processed through IPN secured network.",
      image: "assets/images/onboarding2.png",
    ),
    OnboardingItem(
      title: "Financial Services",
      description:
          "You can now check your transactions history and balance through Instapay",
      image: "assets/images/onboarding3.png",
    ),
    OnboardingItem(
      title: "Collect Money",
      description:
          "Collect money from other users by entering their instant payment address or mobile number",
      image: "assets/images/onboarding4.png",
    ),
  ];
}
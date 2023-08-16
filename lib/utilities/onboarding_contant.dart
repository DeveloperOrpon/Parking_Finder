class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Find Parking Places Around You Easily",
    image: "assets/image/onboarding_car.png",
    desc: "Remember to keep track of your professional accomplishments.",
  ),
  OnboardingContents(
    title: "Book And Pay Parking Quickly & Safely",
    image: "assets/image/onboarding_carparking.png",
    desc:
        "But understanding the contributions our colleagues make to our teams and companies.",
  ),
  OnboardingContents(
    title: "Extend Parking Time As You Need",
    image: "assets/image/onboarding_world.png",
    desc:
        "Take control of notifications, collaborate live or on your own time.",
  ),
];

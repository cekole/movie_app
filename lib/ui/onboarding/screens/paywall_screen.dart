import 'package:flutter/material.dart';
import 'package:movie_app/config/app_config.dart';

import '../../core/themes/app_colors.dart';

enum SubscriptionPlan { weekly, monthly, yearly }

class PaywallScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const PaywallScreen({super.key, required this.onContinue});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  SubscriptionPlan _selectedPlan = SubscriptionPlan.yearly;
  bool _enableFreeTrial = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.white),
          onPressed: widget.onContinue,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Text(
                AppConfig.appName,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              // Feature comparison
              _buildFeatureRow('Daily Movie Suggestions'),
              _buildFeatureRow('AI-Powered Movie Insights'),
              _buildFeatureRow('Personalized Watchlists'),
              _buildFeatureRow('Ad-Free Experience'),
              const SizedBox(height: 32),
              // Free trial toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enable Free Trial',
                    style: TextStyle(color: AppColors.white, fontSize: 16),
                  ),
                  Switch(
                    value: _enableFreeTrial,
                    onChanged: (value) {
                      setState(() {
                        _enableFreeTrial = value;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Subscription options
              _buildSubscriptionOption(
                plan: SubscriptionPlan.weekly,
                title: 'Weekly',
                price: '\$4.99 / week',
              ),
              const SizedBox(height: 12),
              _buildSubscriptionOption(
                plan: SubscriptionPlan.monthly,
                title: 'Monthly',
                price: '\$11.86 / month',
                subtitle: 'only \$0.84 per day',
              ),
              const SizedBox(height: 12),
              _buildSubscriptionOption(
                plan: SubscriptionPlan.yearly,
                title: 'Yearly',
                price: '\$49.99 / year',
                isBestValue: true,
              ),
              const Spacer(),
              // CTA Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: widget.onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Unlock MovieAI PRO',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Terms & Links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Terms of Service',
                      style: TextStyle(color: AppColors.grayDark, fontSize: 12),
                    ),
                  ),
                  const Text('•', style: TextStyle(color: AppColors.grayDark)),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Restore Purchases',
                      style: TextStyle(color: AppColors.grayDark, fontSize: 12),
                    ),
                  ),
                  const Text('•', style: TextStyle(color: AppColors.grayDark)),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(color: AppColors.grayDark, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(color: AppColors.white, fontSize: 14),
            ),
          ),
          // FREE column
          SizedBox(
            width: 50,
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.grayDark),
                ),
              ),
            ),
          ),
          // PRO column
          SizedBox(
            width: 50,
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOption({
    required SubscriptionPlan plan,
    required String title,
    required String price,
    String? subtitle,
    bool isBestValue = false,
  }) {
    final isSelected = _selectedPlan == plan;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = plan;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grayDark,
            width: isSelected ? 2 : 1,
          ),
          color:
              isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grayDark,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child:
                  isSelected
                      ? const Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: 16,
                      )
                      : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.grayDark,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

void main() {
  runApp(const MortgageCalculatorApp());
}

class MortgageCalculatorApp extends StatelessWidget {
  const MortgageCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mortgage Calculator',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        fontFamily: 'Inter',
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  double _purchasePrice = 250000;
  double _downPayment = 50000;
  double _repaymentTime = 25;
  double _interestRate = 3;

  // Function to calculate the mortgage
  Map<String, double> _calculateMortgage() {
    // P = the principal loan amount (Purchase Price - Down Payment)
    final double principal = _purchasePrice - _downPayment;

    // r = your monthly interest rate
    final double monthlyInterestRate = (_interestRate / 100) / 12;

    // n = number of payments over the loan’s lifetime.
    final double numberOfPayments = _repaymentTime * 12;

    // M = P[r(1+r)^n/((1+r)^n)-1)]
    if (numberOfPayments > 0 && monthlyInterestRate > 0) {
      final double monthlyPayment = principal *
          (monthlyInterestRate * pow(1 + monthlyInterestRate, numberOfPayments)) /
          (pow(1 + monthlyInterestRate, numberOfPayments) - 1);
      return {'loanAmount': principal, 'monthlyPayment': monthlyPayment};
    }

    return {'loanAmount': principal, 'monthlyPayment': 0};
  }

  @override
  Widget build(BuildContext context) {
    final results = _calculateMortgage();
    final loanAmount = results['loanAmount'] ?? 0;
    final monthlyPayment = results['monthlyPayment'] ?? 0;

    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Mortgage Calculator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            )
        ),
        centerTitle: true, // Titre centré
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSliderCard(
                label: 'Purchase price:',
                value: _purchasePrice,
                displayValue: currencyFormat.format(_purchasePrice.round()),
                min: 50000,
                max: 1000000,
                divisions: 190,
                onChanged: (value) {
                  setState(() {
                    _purchasePrice = value;
                    if (_downPayment > _purchasePrice) {
                      _downPayment = _purchasePrice;
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildSliderCard(
                label: 'Down payment:',
                value: _downPayment,
                displayValue: currencyFormat.format(_downPayment.round()),
                min: 0,
                max: _purchasePrice,
                divisions: (_purchasePrice/1000).round(),
                onChanged: (value) {
                  setState(() {
                    _downPayment = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildSliderCard(
                label: 'Repayment time:',
                value: _repaymentTime,
                displayValue: '${_repaymentTime.round()} years',
                min: 5,
                max: 30,
                divisions: 25,
                onChanged: (value) {
                  setState(() {
                    _repaymentTime = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildSliderCard(
                label: 'Interest rate:',
                value: _interestRate,
                displayValue: '${_interestRate.toStringAsFixed(2)}%',
                min: 1,
                max: 10,
                divisions: 90,
                onChanged: (value) {
                  setState(() {
                    _interestRate = value;
                  });
                },
              ),
              const SizedBox(height: 40),
              _buildResultSection(
                  'Loan amount', currencyFormat.format(loanAmount.round())),
              const SizedBox(height: 20),
              _buildResultSection('Estimated pr. month:',
                  currencyFormat.format(monthlyPayment.round())),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mortgage quote feature coming soon!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter'
                    ),
                  ),
                  child: const Text('Get a mortgage quote'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderCard({
    required String label,
    required double value,
    required String displayValue,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
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
                label,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              Text(
                displayValue,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions > 0 ? divisions : null,
            label: displayValue,
            onChanged: onChanged,
            activeColor: Colors.deepPurple,
            inactiveColor: Colors.deepPurple.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        ),
      ],
    );
  }
}

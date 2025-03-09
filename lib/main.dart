import 'package:flutter/material.dart';

void main() {
  runApp(const StockCostCalculatorApp());
}

class StockCostCalculatorApp extends StatelessWidget {
  const StockCostCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '股票成本计算器',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StockCostCalculatorPage(),
    );
  }
}

class StockCostCalculatorPage extends StatefulWidget {
  const StockCostCalculatorPage({super.key});

  @override
  _StockCostCalculatorPageState createState() =>
      _StockCostCalculatorPageState();
}

class _StockCostCalculatorPageState extends State<StockCostCalculatorPage> {
  final TextEditingController _currentPriceController = TextEditingController();
  final TextEditingController _currentCostController = TextEditingController();
  final TextEditingController _currentSharesController =
  TextEditingController();
  final TextEditingController _tradeSharesController = TextEditingController();
  final TextEditingController _tradePriceController = TextEditingController();

  String _result = '';

  final FocusNode _currentPriceFocus = FocusNode();
  final FocusNode _currentCostFocus = FocusNode();
  final FocusNode _currentSharesFocus = FocusNode();
  final FocusNode _tradeSharesFocus = FocusNode();
  final FocusNode _tradePriceFocus = FocusNode();

  void _calculateCost() {
    final currentPrice = double.tryParse(_currentPriceController.text) ?? 0;
    final currentCost = double.tryParse(_currentCostController.text) ?? 0;
    final currentShares = int.tryParse(_currentSharesController.text) ?? 0;
    final tradeShares = int.tryParse(_tradeSharesController.text) ?? 0;
    final tradePrice = double.tryParse(_tradePriceController.text) ?? 0;

    // 计算总成本
    double totalCost = currentShares * currentCost + tradeShares * tradePrice;
    // 计算总股数
    int totalShares = currentShares + tradeShares;
    // 计算新的成本价格
    double newCost = totalShares > 0 ? totalCost / totalShares : 0;

    setState(() {
      _result = '最新的成本价格: ${newCost.toStringAsFixed(3)}';
    });
  }

  void _clearInputs() {
    setState(() {
      _currentPriceController.clear();
      _currentCostController.clear();
      _currentSharesController.clear();
      _tradeSharesController.clear();
      _tradePriceController.clear();
      _result = '';
    });
  }

  @override
  void dispose() {
    _currentPriceController.dispose();
    _currentCostController.dispose();
    _currentSharesController.dispose();
    _tradeSharesController.dispose();
    _tradePriceController.dispose();
    _currentPriceFocus.dispose();
    _currentCostFocus.dispose();
    _currentSharesFocus.dispose();
    _tradeSharesFocus.dispose();
    _tradePriceFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '股票成本计算器',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              _buildInputField(
                '当前最新股票价格',
                _currentPriceController,
                _currentPriceFocus,
                _currentCostFocus,
                TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 15),
              _buildInputField(
                '当前成本价格',
                _currentCostController,
                _currentCostFocus,
                _currentSharesFocus,
                TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 15),
              _buildInputField(
                '当前已购股数',
                _currentSharesController,
                _currentSharesFocus,
                _tradeSharesFocus,
                TextInputType.number,
              ),
              const SizedBox(height: 15),
              _buildInputField(
                '即将买卖的股数',
                _tradeSharesController,
                _tradeSharesFocus,
                _tradePriceFocus,
                TextInputType.number,
              ),
              const SizedBox(height: 15),
              _buildInputField(
                '即将买卖的价格',
                _tradePriceController,
                _tradePriceFocus,
                FocusNode(),
                TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),
              _buildCalculateButton(),
              const SizedBox(height: 20),
              _buildClearButton(), // 添加清空按钮
              const SizedBox(height: 20),
              _buildResultText(),
              const SizedBox(height: 50),
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Text(
                      'Copyright © Neaya～JMChen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Version: 1.0.0',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String labelText,
      TextEditingController controller,
      FocusNode currentFocus,
      FocusNode nextFocus,
      TextInputType keyboardType,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        focusNode: currentFocus,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        onSubmitted: (value) {
          FocusScope.of(context).requestFocus(nextFocus);
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return ElevatedButton(
      onPressed: _calculateCost,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      child: const Text(
        '计算成本',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildClearButton() {
    return ElevatedButton(
      onPressed: _clearInputs,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // 设置按钮背景颜色为红色
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      child: const Text(
        '清空输入',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildResultText() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      child: Text(
        _result,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

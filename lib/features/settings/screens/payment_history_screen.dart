import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Payment history screen for viewing payment transactions
class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List<PaymentTransaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));
    
    // TODO: Load from API
    setState(() {
      _transactions = [
        PaymentTransaction(
          id: '1',
          amount: 29.99,
          currency: 'USD',
          status: TransactionStatus.completed,
          date: DateTime.now().subtract(const Duration(days: 1)),
          description: 'Premium Monthly Subscription',
          paymentMethod: 'Credit Card ****1234',
        ),
        PaymentTransaction(
          id: '2',
          amount: 29.99,
          currency: 'USD',
          status: TransactionStatus.completed,
          date: DateTime.now().subtract(const Duration(days: 32)),
          description: 'Premium Monthly Subscription',
          paymentMethod: 'Credit Card ****1234',
        ),
        PaymentTransaction(
          id: '3',
          amount: 29.99,
          currency: 'USD',
          status: TransactionStatus.completed,
          date: DateTime.now().subtract(const Duration(days: 63)),
          description: 'Premium Monthly Subscription',
          paymentMethod: 'Credit Card ****1234',
        ),
        PaymentTransaction(
          id: '4',
          amount: 29.99,
          currency: 'USD',
          status: TransactionStatus.failed,
          date: DateTime.now().subtract(const Duration(days: 94)),
          description: 'Premium Monthly Subscription',
          paymentMethod: 'Credit Card ****1234',
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadStatement,
            tooltip: 'Download Statement',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? _buildEmptyState()
              : _buildTransactionList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Payment History',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your payment transactions will appear here',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Column(
      children: [
        // Summary Card
        _buildSummaryCard(),
        const SizedBox(height: 16),
        
        // Transactions List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              return _buildTransactionCard(_transactions[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    final totalAmount = _transactions
        .where((t) => t.status == TransactionStatus.completed)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    final totalTransactions = _transactions.length;
    final successfulTransactions = _transactions
        .where((t) => t.status == TransactionStatus.completed)
        .length;

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Total Spent',
                    '\$${totalAmount.toStringAsFixed(2)}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Transactions',
                    '$totalTransactions',
                    Icons.receipt,
                    AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Successful',
                    '$successfulTransactions',
                    Icons.check_circle,
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTransactionCard(PaymentTransaction transaction) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(transaction.status).withValues(alpha: 0.1),
          child: Icon(
            _getStatusIcon(transaction.status),
            color: _getStatusColor(transaction.status),
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              _formatDate(transaction.date),
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              transaction.paymentMethod,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${transaction.currency} ${transaction.amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getStatusColor(transaction.status),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(transaction.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getStatusText(transaction.status),
                style: TextStyle(
                  color: _getStatusColor(transaction.status),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showTransactionDetails(transaction),
      ),
    );
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return Colors.green;
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.failed:
        return Colors.red;
      case TransactionStatus.refunded:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return Icons.check_circle;
      case TransactionStatus.pending:
        return Icons.schedule;
      case TransactionStatus.failed:
        return Icons.error;
      case TransactionStatus.refunded:
        return Icons.refresh;
    }
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.refunded:
        return 'Refunded';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showTransactionDetails(PaymentTransaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Transaction ID', transaction.id),
            _buildDetailRow('Amount', '${transaction.currency} ${transaction.amount.toStringAsFixed(2)}'),
            _buildDetailRow('Status', _getStatusText(transaction.status)),
            _buildDetailRow('Date', _formatDate(transaction.date)),
            _buildDetailRow('Description', transaction.description),
            _buildDetailRow('Payment Method', transaction.paymentMethod),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _downloadStatement() {
    // TODO: Implement statement download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloading payment statement...'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

enum TransactionStatus {
  completed,
  pending,
  failed,
  refunded,
}

class PaymentTransaction {
  final String id;
  final double amount;
  final String currency;
  final TransactionStatus status;
  final DateTime date;
  final String description;
  final String paymentMethod;

  PaymentTransaction({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.date,
    required this.description,
    required this.paymentMethod,
  });
} 
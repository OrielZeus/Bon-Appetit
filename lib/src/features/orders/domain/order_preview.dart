class OrderPreview {
  const OrderPreview({
    required this.code,
    required this.customer,
    required this.total,
    required this.status,
  });

  factory OrderPreview.fromJson(Map<String, dynamic> json) {
    return OrderPreview(
      code: json['code'] as String? ?? 'BA-0000',
      customer: json['customer'] as String? ?? 'Customer',
      total: (json['total'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'Draft',
    );
  }

  final String code;
  final String customer;
  final double total;
  final String status;
}

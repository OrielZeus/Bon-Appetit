class OrderPreview {
  const OrderPreview({
    required this.code,
    required this.customer,
    required this.total,
    required this.status,
  });

  final String code;
  final String customer;
  final double total;
  final String status;
}

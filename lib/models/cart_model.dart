class CartModel {
  final int? id;
  final String userName;
  final String product;
  final double amount;
  final String status; // abandoned, follow_up, converted
  final String time;

  CartModel({
    this.id,
    required this.userName,
    required this.product,
    required this.amount,
    required this.status,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'product': product,
      'amount': amount,
      'status': status,
      'time': time,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'],
      userName: map['userName'],
      product: map['product'],
      amount: map['amount'],
      status: map['status'],
      time: map['time'],
    );
  }
}
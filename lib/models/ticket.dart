class Ticket {
  final int ticketId;
  final DateTime raisedAt;
  final String orderName;
  final String orderUser;

  Ticket({
    required this.ticketId,
    required this.orderName,
    required this.orderUser,
    required this.raisedAt,
  });
}

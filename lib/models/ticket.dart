class Ticket {
  final String ticketId;
  final String userID;
  final String itemIDs;
  final double totalValue;
  final DateTime raisedAt;

  Ticket({
    required this.userID,
    required this.itemIDs,
    required this.totalValue,
    required this.ticketId,
    required this.raisedAt,
  });
}

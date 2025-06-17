class JobTransactionDetail {
  final String idTransaction;
  final String? amountFormatted;
  final String? amountInWords;
  final String? senderName;
  final String? senderBank;
  final String? receiverName;
  final String? receiverBank;
  final String? content;
  final String? fee;

  JobTransactionDetail({
    required this.idTransaction,
    this.amountFormatted,
    this.amountInWords,
    this.senderName,
    this.senderBank,
    this.receiverName,
    this.receiverBank,
    this.content,
    this.fee,
  });

  // Factory constructor để tạo từ JSON (Map)
  factory JobTransactionDetail.fromJson(Map<String, dynamic> json) {
    return JobTransactionDetail(
      idTransaction: json['idTransaction'] as String,
      amountFormatted: json['amountFormatted'] as String?,
      amountInWords: json['amountInWords'] as String?,
      senderName: json['senderName'] as String?,
      senderBank: json['senderBank'] as String?,
      receiverName: json['receiverName'] as String?,
      receiverBank: json['receiverBank'] as String?,
      content: json['content'] as String?,
      fee: json['fee'] as String?,
    );
  }

  // Chuyển object thành JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'idTransaction': idTransaction,
      'amountFormatted': amountFormatted,
      'amountInWords': amountInWords,
      'senderName': senderName,
      'senderBank': senderBank,
      'receiverName': receiverName,
      'receiverBank': receiverBank,
      'content': content,
      'fee': fee,
    };
  }
}

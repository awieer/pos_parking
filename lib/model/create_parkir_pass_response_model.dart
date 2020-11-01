class CreateParkirPassResponse {
  String transactionId;
  int paymentId;
  int parkingPassId;

  CreateParkirPassResponse(
      this.transactionId, this.paymentId, this.parkingPassId);

  CreateParkirPassResponse.fromJson(Map<String, dynamic> json)
      : transactionId = json["transaction_id"],
        paymentId = json["payment_id"],
        parkingPassId = json["parking_pass_id"];
}

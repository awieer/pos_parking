class CouponModel {
  bool success;
  String message;
  List<CouponPass> data;

  CouponModel(this.success, this.message, this.data);

  CouponModel.fromJson(Map<String, dynamic> json)
      : success = json["success"],
        message = json["message"],
        data = json["data"] != null
            ? (json["data"] as List).map((i) => CouponPass.fromJson(i)).toList()
            : null;
}

class CouponPass {
  int id;
  String code;
  String reductionType;
  String reduction;

  CouponPass(this.id, this.code, this.reductionType, this.reduction);

  CouponPass.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        code = json["code"],
        reductionType = json["reduction_type"],
        reduction = json["reduction"];
}

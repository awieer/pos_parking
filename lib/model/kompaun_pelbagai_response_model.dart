class KompaunPelbagaiResponse {
  bool success;
  String message;
  Params params;
  List<KompaunPelbagaiData> data;
  bool responseFromMpk;

  KompaunPelbagaiResponse(
      this.success, this.message, this.params, this.data, this.responseFromMpk);

  KompaunPelbagaiResponse.fromJson(Map<String, dynamic> json)
      : success = json["success"],
        message = json["message"],
        params = Params.fromJson(json["params"]),
        data = (json["data"] as List)
            .map((i) => KompaunPelbagaiData.fromJson(i))
            .toList(),
        responseFromMpk = json["responseFromMpk"];
}

class Params {
  String searchvalue;
  String councilid;
  String searchtype;
  String refsource;
  String secretkey;

  Params(this.searchvalue, this.councilid, this.searchtype, this.refsource,
      this.secretkey);

  Params.fromJson(Map<String, dynamic> json)
      : searchvalue = json["searchvalue"],
        councilid = json["councilid"],
        searchtype = json["searchtype"],
        refsource = json["refsource"],
        secretkey = json["secretkey"];
}

class KompaunPelbagaiData {
  String status;
  String offenderName;
  String offenderId;
  // String companyName;
  // String companyNumber;
  String serviceReference1;
  String serviceReference2;
  String violationLocation;
  String violationTimestamp;
  String violationType;
  int compoundAmount;

  KompaunPelbagaiData(
      this.status,
      this.offenderName,
      this.offenderId,
      // this.companyName,
      // this.companyNumber,
      this.serviceReference1,
      this.serviceReference2,
      this.violationLocation,
      this.violationTimestamp,
      this.violationType,
      this.compoundAmount);

  KompaunPelbagaiData.fromJson(Map<String, dynamic> json)
      : status = json["status"],
        offenderName = json["offender_name"],
        offenderId = json["offender_id"],
        // companyName = json["company_name"],
        // companyNumber = json["company_number"],
        serviceReference1 = json["service_reference_1"],
        serviceReference2 = json["service_reference_2"],
        violationLocation = json["violation_location"],
        violationTimestamp = json["violation_timestamp"],
        violationType = json["violation_type"],
        compoundAmount = json["compound_amount"];
}

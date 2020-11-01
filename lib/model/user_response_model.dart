class UserResponse {
  bool success;
  UserData data;

  UserResponse(this.success, this.data);

  UserResponse.fromJson(Map<String, dynamic> json)
      : success = json["success"],
        data = UserData.fromJson(json["data"]);
}

class UserData {
  int id;
  String uid;
  String name;
  String username;
  String email;
  String rememberToken;
  String phone;
  String ic;
  String gender;
  int status;
  String authToken;
  String picture;
  String createdAt;
  String updatedAt;
  String lastLogin;
  String address;
  String designation;
  String department;
  String channel;
  String oautToken;
  int pgoToken;
  LinkAccount linkedAccounts;
  int isEmailVerified;
  int isPhoneVerified;
  String language;
  String appVersion;
  String passport;
  String nationality;

  UserData(
      this.id,
      this.uid,
      this.name,
      this.username,
      this.email,
      this.rememberToken,
      this.phone,
      this.ic,
      this.gender,
      this.status,
      this.authToken,
      this.picture,
      this.createdAt,
      this.updatedAt,
      this.lastLogin,
      this.address,
      this.designation,
      this.department,
      this.channel,
      this.oautToken,
      this.pgoToken,
      this.linkedAccounts,
      this.isEmailVerified,
      this.isPhoneVerified,
      this.language,
      this.appVersion,
      this.passport,
      this.nationality);

  UserData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        uid = json["uid"],
        name = json["name"],
        username = json["username"],
        email = json["email"],
        rememberToken = json["remember_token"],
        phone = json["phone"],
        ic = json["ic"],
        gender = json["gender"],
        status = json["status"],
        authToken = json["auth_token"],
        picture = json["picture"],
        createdAt = json["created_at"],
        updatedAt = json["updated_at"],
        lastLogin = json["last_login"],
        address = json["address"],
        designation = json["designation"],
        department = json["department"],
        channel = json["channel"],
        oautToken = json["oaut_token"],
        pgoToken = json["pgo_token"],
        linkedAccounts = LinkAccount.fromJson(json["linked_accounts"]),
        isEmailVerified = json["is_email_verified"],
        isPhoneVerified = json["is_phone_verified"],
        language = json["language"],
        appVersion = json["app_version"],
        passport = json["passport"],
        nationality = json["nationality"];
}

class LinkAccount {
  String email;
  String google;
  String facebook;
  String name;

  LinkAccount(this.email, this.google, this.facebook, this.name);

  LinkAccount.fromJson(Map<String, dynamic> json)
      : email = json["email"],
        google = json["google"],
        facebook = json["facebook"],
        name = json["name"];
}

class UserResponseError {
  bool success;
  String status;

  UserResponseError(this.success, this.status);

  UserResponseError.fromJson(Map<String, dynamic> json)
      : success = json["success"],
        status = json["status"];
}

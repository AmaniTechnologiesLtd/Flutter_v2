class CustomerInfoModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? status;
  List<KYCRuleModel>? rules;
  List<KYCRuleModel>? missingRules;
  String? idCardNumber;
  String? occupation;
  String? city;
  String? address;
  String? province;

  CustomerInfoModel({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? status,
    List<KYCRuleModel>? rules,
    List<KYCRuleModel>? missingRules,
    String? idCardNumber,
    String? occupation,
    String? city,
    String? address,
    String? province,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "status": status,
      "rules": rules,
      "missingRules": missingRules,
      "idCardNumber": idCardNumber,
      "occupation": occupation,
      "city": city,
      "address": address,
      "province": province,
    };
  }

  CustomerInfoModel.fromMap(Map<String, dynamic> map) {
    List<KYCRuleModel> rules = [];
    List<KYCRuleModel> missingRules = [];

    final ruleList = map["rules"];
    final missingRuleList = map["missingRules"];

    for (var rule in ruleList) {
      final ruleMap = Map<String, dynamic>.from(rule);
      rules.add(KYCRuleModel.fromMap(ruleMap));
    }

    for (var rule in missingRuleList) {
      final ruleMap = Map<String, dynamic>.from(rule);
      missingRules.add(KYCRuleModel.fromMap(ruleMap));
    }

    // fill the instance data.
    id = map["id"];
    name = map["name"];
    email = map["email"];
    phone = map["phone"];
    occupation = map["occupation"];
    city = map["city"];
    address = map["address"];
    province = map["province"];
    this.rules = rules;
    this.missingRules = missingRules;
  }
}

class KYCRuleModel {
  String? id;
  String? title;
  List<String>? documentClasses;
  String? status;

  KYCRuleModel({
    String? id,
    String? title,
    List<String>? documentClasses,
    String? status,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "documentClasses": documentClasses,
      "status": status
    };
  }

  KYCRuleModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    documentClasses = List<String>.from(map["documentClasses"]);
    status = map["status"];
  }
}

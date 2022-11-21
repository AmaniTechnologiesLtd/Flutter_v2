class NviModel {
  ///Document no
  String documentNo;

  ///Date of birth formatted with "YYYY/MM/DD"
  String dateOfBirth;

  ///Date of expire  formatted with "YYYY/MM/DD"
  String dateOfExpire;

  NviModel(this.documentNo, this.dateOfBirth, this.dateOfExpire);

  Map toMap() {
    return {
      "documentNo": documentNo,
      "dateOfBirth": dateOfBirth,
      "dateOfExpire": dateOfExpire
    };
  }
}

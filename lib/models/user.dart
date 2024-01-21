
class User {

  String? token;
  String? tokenType;
  int? expiryDate;
  String? name;
  String? image;
  String? email;
  String? id;
  String? phone;
  int? numberOfInterpretedDreams;
  double? availableBalance;
  double? transferedBalance;
  String? firebaseId;

  User({
     this.expiryDate,
     this.tokenType,
     this.name,
     this.image,
     this.token,
     this.email,
     this.id,
     this.phone,
     this.numberOfInterpretedDreams,
     this.transferedBalance,
     this.availableBalance,
     this.firebaseId
  });
}

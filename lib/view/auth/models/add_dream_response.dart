class AddDreamResponse {
  String? status;
  String? description;
  var serviceProviderId;
  var serviceProvider;
  int? servicePathId;
  var servicePath;
  var explanation;
  var explanationDate;
  String? phoneNumber;
  int? paymentId;
  Payment? payment;
  int? id;
  String? creationDate;
  String? lastModificationDate;
  Creator? creator;
  String? creatorId;
  var modifier;
  var modifierId;
  int? attachmentId;
  var creatorName;

  AddDreamResponse(
      { this.status,
       this.description,
      this.serviceProviderId,
      this.serviceProvider,
       this.servicePathId,
      this.servicePath,
      this.explanation,
      this.explanationDate,
       this.phoneNumber,
       this.paymentId,
       this.payment,
       this.id,
       this.creationDate,
       this.lastModificationDate,
       this.creator,
       this.creatorId,
      this.modifier,
      this.modifierId,
       this.attachmentId,
      this.creatorName});

  AddDreamResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    description = json['Description'];
    serviceProviderId = json['ServiceProviderId'];
    serviceProvider = json['ServiceProvider'];
    servicePathId = json['ServicePathId'];
    servicePath = json['ServicePath'];
    explanation = json['Explanation'];
    explanationDate = json['ExplanationDate'];
    phoneNumber = json['PhoneNumber'];
    paymentId = json['PaymentId'];
    payment =
        (json['Payment'] != null ? new Payment.fromJson(json['Payment']) : null)!;
    id = json['id'];
    creationDate = json['CreationDate'];
    lastModificationDate = json['LastModificationDate'];
    creator =
        (json['Creator'] != null ? new Creator.fromJson(json['Creator']) : null)!;
    creatorId = json['CreatorId'];
    modifier = json['Modifier'];
    modifierId = json['ModifierId'];
    attachmentId = json['AttachmentId'];
    creatorName = json['CreatorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Description'] = this.description;
    data['ServiceProviderId'] = this.serviceProviderId;
    data['ServiceProvider'] = this.serviceProvider;
    data['ServicePathId'] = this.servicePathId;
    data['ServicePath'] = this.servicePath;
    data['Explanation'] = this.explanation;
    data['ExplanationDate'] = this.explanationDate;
    data['PhoneNumber'] = this.phoneNumber;
    data['PaymentId'] = this.paymentId;
    if (this.payment != null) {
      data['Payment'] = this.payment?.toJson();
    }
    data['id'] = this.id;
    data['CreationDate'] = this.creationDate;
    data['LastModificationDate'] = this.lastModificationDate;
    if (this.creator != null) {
      data['Creator'] = this.creator?.toJson();
    }
    data['CreatorId'] = this.creatorId;
    data['Modifier'] = this.modifier;
    data['ModifierId'] = this.modifierId;
    data['AttachmentId'] = this.attachmentId;
    data['CreatorName'] = this.creatorName;
    return data;
  }
}

class Payment {
  num? amount;
  String? method;
  String? currency;
  String? status;
  int? id;
  String? creationDate;
  String? lastModificationDate;
  var creator;
  var creatorId;
  var modifier;
  var modifierId;

  int? attachmentId;
  late var creatorName;

  Payment(
      { this.amount,
       this.method,
       this.currency,
       this.status,
       this.id,
       this.creationDate,
       this.lastModificationDate,
       this.creator,
       this.creatorId,
       this.modifier,
         this.modifierId,
         this.attachmentId,
         this.creatorName});

  Payment.fromJson(Map<String, dynamic> json) {
    amount = json['Amount'];
    method = json['Method'];
    currency = json['Currency'];
    status = json['Status'];
    id = json['id'];
    creationDate = json['CreationDate'];
    lastModificationDate = json['LastModificationDate'];
    creator = json['Creator'];
    creatorId = json['CreatorId'];
    modifier = json['Modifier'];
    modifierId = json['ModifierId'];
    attachmentId = json['AttachmentId'];
    creatorName = json['CreatorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Amount'] = this.amount;
    data['Method'] = this.method;
    data['Currency'] = this.currency;
    data['Status'] = this.status;
    data['id'] = this.id;
    data['CreationDate'] = this.creationDate;
    data['LastModificationDate'] = this.lastModificationDate;
    data['Creator'] = this.creator;
    data['CreatorId'] = this.creatorId;
    data['Modifier'] = this.modifier;
    data['ModifierId'] = this.modifierId;
    data['AttachmentId'] = this.attachmentId;
    data['CreatorName'] = this.creatorName;
    return data;
  }
}

class Creator {
  List<dynamic>? claims;
  List<dynamic>? logins;
  List<dynamic>? roles;
  String? creationDate;
  String? lastModificationDate;
  String? name;
  String? type;
  String? status;
  String? pictureId;
  String? email;
  bool? emailConfirmed;
  String? passwordHash;
  String? securityStamp;
  String? phoneNumber;
  bool? phoneNumberConfirmed;
  bool? twoFactorEnabled;
  var lockoutEndDateUtc;
  bool? lockoutEnabled;
  int? accessFailedCount;
  String? id;
  String? userName;

  Creator(
      {this.claims,
      this.logins,
      this.roles,
      this.creationDate,
      this.lastModificationDate,
      this.name,
      this.type,
      this.status,
      this.pictureId,
      this.email,
      this.emailConfirmed,
      this.passwordHash,
      this.securityStamp,
      this.phoneNumber,
      this.phoneNumberConfirmed,
      this.twoFactorEnabled,
      this.lockoutEndDateUtc,
      this.lockoutEnabled,
      this.accessFailedCount,
      this.id,
      this.userName});

  Creator.fromJson(Map<String, dynamic> json) {
    if (json['Claims'] != null) {
      claims = <dynamic>[];
    }
    if (json['Logins'] != null) {
      logins = <dynamic>[];
      json['Logins'].forEach((v) {});
    }
    if (json['Roles'] != null) {
      roles = <dynamic>[];
      json['Roles'].forEach((v) {});
    }
    creationDate = json['CreationDate'];
    lastModificationDate = json['LastModificationDate'];
    name = json['Name'];
    type = json['Type'];
    status = json['Status'];
    pictureId = json['PictureId'];
    email = json['Email'];
    emailConfirmed = json['EmailConfirmed'];
    passwordHash = json['PasswordHash'];
    securityStamp = json['SecurityStamp'];
    phoneNumber = json['PhoneNumber'];
    phoneNumberConfirmed = json['PhoneNumberConfirmed'];
    twoFactorEnabled = json['TwoFactorEnabled'];
    lockoutEndDateUtc = json['LockoutEndDateUtc'];
    lockoutEnabled = json['LockoutEnabled'];
    accessFailedCount = json['AccessFailedCount'];
    id = json['Id'];
    userName = json['UserName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.claims != null) {}
    if (this.logins != null) {}
    if (this.roles != null) {}
    data['CreationDate'] = this.creationDate;
    data['LastModificationDate'] = this.lastModificationDate;
    data['Name'] = this.name;
    data['Type'] = this.type;
    data['Status'] = this.status;
    data['PictureId'] = this.pictureId;
    data['Email'] = this.email;
    data['EmailConfirmed'] = this.emailConfirmed;
    data['PasswordHash'] = this.passwordHash;
    data['SecurityStamp'] = this.securityStamp;
    data['PhoneNumber'] = this.phoneNumber;
    data['PhoneNumberConfirmed'] = this.phoneNumberConfirmed;
    data['TwoFactorEnabled'] = this.twoFactorEnabled;
    data['LockoutEndDateUtc'] = this.lockoutEndDateUtc;
    data['LockoutEnabled'] = this.lockoutEnabled;
    data['AccessFailedCount'] = this.accessFailedCount;
    data['Id'] = this.id;
    data['UserName'] = this.userName;
    return data;
  }
}

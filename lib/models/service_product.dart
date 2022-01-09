class ServiceProduct {
  List<Data>? data;

  ServiceProduct({this.data});

  ServiceProduct.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? productId;
  String? productGroupId;
  String? productModelId;
  String? warrantyId;
  String? productCode;
  String? productDescription;
  String? insertedAt;
  String? updatedAt;
  String? productGroup;
  String? productGroupDescription;
  String? productModel;
  String? modelDescription;
  String? mapToProductCode;
  String? isActive;
  String? specificWarranty;
  String? dropIn;
  String? homeVisit;
  String? pickUp;
  String? serviceHours;
  String? technicianServiceGroup;
  String? rcp;
  String? extendedWarrantyCharge1yr;
  String? repairWithPartRepChargeIndoor;
  String? checkingAdjChargeIndoor;
  String? checkingAdjChargeOutdoor;
  String? repairWithPartRepChargeOutdoor;
  String? grrCharge;
  String? transportChargeLess50km;
  String? transportChargeBetween50km100km;
  String? transportChargeGreater100km;
  String? warrantyRegistrationId;
  String? userId;
  String? storeId;
  String? serviceCenterId;
  String? adminApprovalStatusId;
  String? purchaseDate;
  String? referralCode;
  String? receiptFile;
  String? extendedWarrantyId;
  String? serialNo;
  String? isSendSmsQueue;
  String? smsNumber;
  String? smsSentDatetime;
  String? iDontHaveThisAnymore;
  String? insertedBy;
  String? updatedBy;
  String? roleId;
  String? addressId;
  String? email;
  String? firstName;
  String? middleName;
  String? lastName;
  String? fullName;
  String? gender;
  String? dateOfBirth;
  String? civilStatus;
  String? telephone;
  String? telephone2;
  String? fax;
  String? mobilePhone;
  String? employeeCode;
  String? jobTitle;
  String? firstDateOfEmployment;
  String? lastDateOfEmployment;
  String? managerEmployeeCode;
  String? lastLoginDatetime;

  Data(
      {this.productId,
      this.productGroupId,
      this.productModelId,
      this.warrantyId,
      this.productCode,
      this.productDescription,
      this.insertedAt,
      this.updatedAt,
      this.productGroup,
      this.productGroupDescription,
      this.productModel,
      this.modelDescription,
      this.mapToProductCode,
      this.isActive,
      this.specificWarranty,
      this.dropIn,
      this.homeVisit,
      this.pickUp,
      this.serviceHours,
      this.technicianServiceGroup,
      this.rcp,
      this.extendedWarrantyCharge1yr,
      this.repairWithPartRepChargeIndoor,
      this.checkingAdjChargeIndoor,
      this.checkingAdjChargeOutdoor,
      this.repairWithPartRepChargeOutdoor,
      this.grrCharge,
      this.transportChargeLess50km,
      this.transportChargeBetween50km100km,
      this.transportChargeGreater100km,
      this.warrantyRegistrationId,
      this.userId,
      this.storeId,
      this.serviceCenterId,
      this.adminApprovalStatusId,
      this.purchaseDate,
      this.referralCode,
      this.receiptFile,
      this.extendedWarrantyId,
      this.serialNo,
      this.isSendSmsQueue,
      this.smsNumber,
      this.smsSentDatetime,
      this.iDontHaveThisAnymore,
      this.insertedBy,
      this.updatedBy,
      this.roleId,
      this.addressId,
      this.email,
      this.firstName,
      this.middleName,
      this.lastName,
      this.fullName,
      this.gender,
      this.dateOfBirth,
      this.civilStatus,
      this.telephone,
      this.telephone2,
      this.fax,
      this.mobilePhone,
      this.employeeCode,
      this.jobTitle,
      this.firstDateOfEmployment,
      this.lastDateOfEmployment,
      this.managerEmployeeCode,
      this.lastLoginDatetime});

  Data.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productGroupId = json['product_group_id'];
    productModelId = json['product_model_id'];
    warrantyId = json['warranty_id'];
    productCode = json['product_code'];
    productDescription = json['product_description'];
    insertedAt = json['inserted_at'];
    updatedAt = json['updated_at'];
    productGroup = json['product_group'];
    productGroupDescription = json['product_group_description'];
    productModel = json['product_model'];
    modelDescription = json['model_description'];
    mapToProductCode = json['map_to_product_code'];
    isActive = json['is_active'];
    specificWarranty = json['specific_warranty'];
    dropIn = json['drop_in'];
    homeVisit = json['home_visit'];
    pickUp = json['pick_up'];
    serviceHours = json['service_hours'];
    technicianServiceGroup = json['technician_service_group'];
    rcp = json['rcp'];
    extendedWarrantyCharge1yr = json['extended_warranty_charge_1yr'];
    repairWithPartRepChargeIndoor = json['repair_with_part_rep_charge_indoor'];
    checkingAdjChargeIndoor = json['checking_adj_charge_indoor'];
    checkingAdjChargeOutdoor = json['checking_adj_charge_outdoor'];
    repairWithPartRepChargeOutdoor =
        json['repair_with_part_rep_charge_outdoor'];
    grrCharge = json['grr_charge'];
    transportChargeLess50km = json['transport_charge_less_50km'];
    transportChargeBetween50km100km =
        json['transport_charge_between_50km_100km'];
    transportChargeGreater100km = json['transport_charge_greater_100km'];
    warrantyRegistrationId = json['warranty_registration_id'];
    userId = json['user_id'];
    storeId = json['store_id'];
    serviceCenterId = json['service_center_id'];
    adminApprovalStatusId = json['admin_approval_status_id'];
    purchaseDate = json['purchase_date'];
    referralCode = json['referral_code'];
    receiptFile = json['receipt_file'];
    extendedWarrantyId = json['extended_warranty_id'];
    serialNo = json['serial_no'];
    isSendSmsQueue = json['is_send_sms_queue'];
    smsNumber = json['sms_number'];
    smsSentDatetime = json['sms_sent_datetime'];
    iDontHaveThisAnymore = json['i_dont_have_this_anymore'];
    insertedBy = json['inserted_by'];
    updatedBy = json['updated_by'];
    roleId = json['role_id'];
    addressId = json['address_id'];
    email = json['email'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    fullName = json['full_name'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    civilStatus = json['civil_status'];
    telephone = json['telephone'];
    telephone2 = json['telephone2'];
    fax = json['fax'];
    mobilePhone = json['mobile_phone'];
    employeeCode = json['employee_code'];
    jobTitle = json['job_title'];
    firstDateOfEmployment = json['first_date_of_employment'];
    lastDateOfEmployment = json['last_date_of_employment'];
    managerEmployeeCode = json['manager_employee_code'];
    lastLoginDatetime = json['last_login_datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_group_id'] = this.productGroupId;
    data['product_model_id'] = this.productModelId;
    data['warranty_id'] = this.warrantyId;
    data['product_code'] = this.productCode;
    data['product_description'] = this.productDescription;
    data['inserted_at'] = this.insertedAt;
    data['updated_at'] = this.updatedAt;
    data['product_group'] = this.productGroup;
    data['product_group_description'] = this.productGroupDescription;
    data['product_model'] = this.productModel;
    data['model_description'] = this.modelDescription;
    data['map_to_product_code'] = this.mapToProductCode;
    data['is_active'] = this.isActive;
    data['specific_warranty'] = this.specificWarranty;
    data['drop_in'] = this.dropIn;
    data['home_visit'] = this.homeVisit;
    data['pick_up'] = this.pickUp;
    data['service_hours'] = this.serviceHours;
    data['technician_service_group'] = this.technicianServiceGroup;
    data['rcp'] = this.rcp;
    data['extended_warranty_charge_1yr'] = this.extendedWarrantyCharge1yr;
    data['repair_with_part_rep_charge_indoor'] =
        this.repairWithPartRepChargeIndoor;
    data['checking_adj_charge_indoor'] = this.checkingAdjChargeIndoor;
    data['checking_adj_charge_outdoor'] = this.checkingAdjChargeOutdoor;
    data['repair_with_part_rep_charge_outdoor'] =
        this.repairWithPartRepChargeOutdoor;
    data['grr_charge'] = this.grrCharge;
    data['transport_charge_less_50km'] = this.transportChargeLess50km;
    data['transport_charge_between_50km_100km'] =
        this.transportChargeBetween50km100km;
    data['transport_charge_greater_100km'] = this.transportChargeGreater100km;
    data['warranty_registration_id'] = this.warrantyRegistrationId;
    data['user_id'] = this.userId;
    data['store_id'] = this.storeId;
    data['service_center_id'] = this.serviceCenterId;
    data['admin_approval_status_id'] = this.adminApprovalStatusId;
    data['purchase_date'] = this.purchaseDate;
    data['referral_code'] = this.referralCode;
    data['receipt_file'] = this.receiptFile;
    data['extended_warranty_id'] = this.extendedWarrantyId;
    data['serial_no'] = this.serialNo;
    data['is_send_sms_queue'] = this.isSendSmsQueue;
    data['sms_number'] = this.smsNumber;
    data['sms_sent_datetime'] = this.smsSentDatetime;
    data['i_dont_have_this_anymore'] = this.iDontHaveThisAnymore;
    data['inserted_by'] = this.insertedBy;
    data['updated_by'] = this.updatedBy;
    data['role_id'] = this.roleId;
    data['address_id'] = this.addressId;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['full_name'] = this.fullName;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['civil_status'] = this.civilStatus;
    data['telephone'] = this.telephone;
    data['telephone2'] = this.telephone2;
    data['fax'] = this.fax;
    data['mobile_phone'] = this.mobilePhone;
    data['employee_code'] = this.employeeCode;
    data['job_title'] = this.jobTitle;
    data['first_date_of_employment'] = this.firstDateOfEmployment;
    data['last_date_of_employment'] = this.lastDateOfEmployment;
    data['manager_employee_code'] = this.managerEmployeeCode;
    data['last_login_datetime'] = this.lastLoginDatetime;
    return data;
  }
}

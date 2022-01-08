import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class Purchase {
  dynamic? warrantyRegistrationId;
  String? userId;
  String? productId;
  String? warrantyId;
  dynamic? storeId;
  dynamic? serviceCenterId;
  dynamic? adminApprovalStatusId;
  String? purchaseDate;
  dynamic? referralCode;
  String? receiptFile;
  dynamic? extendedWarrantyId;
  String? serialNo;
  dynamic? isSendSmsQueue;
  dynamic? smsNumber;
  dynamic? smsSentDatetime;
  String? iDontHaveThisAnymore;
  dynamic? insertedAt;
  dynamic? updatedAt;
  String? insertedBy;
  dynamic? updatedBy;
  String? adminApprovalStatus;
  String? description;
  dynamic? extendedEwarrantyCost;
  String? productGroupId;
  String? productModelId;
  String? productCode;
  String? productDescription;
  String? productGroup;
  String? productGroupDescription;
  String? productModel;
  String? modelDescription;
  String? mapToProductCode;
  String? isActive;
  dynamic? specificWarranty;
  String? dropIn;
  String? homeVisit;
  String? pickUp;
  String? serviceHours;
  dynamic? technicianServiceGroup;
  String? warranty;
  String? warrantyPeriod;
  String? warrantyDescription;
  String? numPeriods;
  String? periodUnit;
  String? warrantyMonths;
  String? roleId;
  String? addressId;
  String? email;
  String? firstName;
  dynamic? middleName;
  dynamic? lastName;
  dynamic? fullName;
  dynamic? gender;
  dynamic? dateOfBirth;
  dynamic? civilStatus;
  String? telephone;
  dynamic? telephone2;
  dynamic? fax;
  String? mobilePhone;
  dynamic? employeeCode;
  dynamic? jobTitle;
  dynamic? firstDateOfEmployment;
  dynamic? lastDateOfEmployment;
  dynamic? managerEmployeeCode;
  dynamic? lastLoginDatetime;
  dynamic? storeName;
  dynamic? bpStatus;
  String? status;
  String? statusCode;

  Purchase(
      {this.warrantyRegistrationId,
      this.userId,
      this.productId,
      this.warrantyId,
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
      this.insertedAt,
      this.updatedAt,
      this.insertedBy,
      this.updatedBy,
      this.adminApprovalStatus,
      this.description,
      this.extendedEwarrantyCost,
      this.productGroupId,
      this.productModelId,
      this.productCode,
      this.productDescription,
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
      this.warranty,
      this.warrantyDescription,
      this.numPeriods,
      this.periodUnit,
      this.warrantyMonths,
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
      this.lastLoginDatetime,
      this.storeName,
      this.bpStatus});

  Purchase.fromJson(Map<String, dynamic> json) {
    this.warrantyRegistrationId = json["warranty_registration_id"];
    this.userId = json["user_id"];
    this.productId = json["product_id"];
    this.warrantyId = json["warranty_id"];
    this.storeId = json["store_id"];
    this.serviceCenterId = json["service_center_id"];
    this.adminApprovalStatusId = json["admin_approval_status_id"];
    this.purchaseDate = json["purchase_date"];
    this.referralCode = json["referral_code"];
    this.receiptFile = json["receipt_file"];
    this.extendedWarrantyId = json["extended_warranty_id"];
    this.serialNo = json["serial_no"];
    this.isSendSmsQueue = json["is_send_sms_queue"];
    this.smsNumber = json["sms_number"];
    this.smsSentDatetime = json["sms_sent_datetime"];
    this.iDontHaveThisAnymore = json["i_dont_have_this_anymore"];
    this.insertedAt = json["inserted_at"];
    this.updatedAt = json["updated_at"];
    this.insertedBy = json["inserted_by"];
    this.updatedBy = json["updated_by"];
    this.adminApprovalStatus = json["admin_approval_status"];
    this.description = json["description"];
    this.extendedEwarrantyCost = json["extended_ewarranty_cost"];
    this.productGroupId = json["product_group_id"];
    this.productModelId = json["product_model_id"];
    this.productCode = json["product_code"];
    this.productDescription = json["product_description"];
    this.productGroup = json["product_group"];
    this.productGroupDescription = json["product_group_description"];
    this.productModel = json["product_model"];
    this.modelDescription = json["model_description"];
    this.mapToProductCode = json["map_to_product_code"];
    this.isActive = json["is_active"];
    this.specificWarranty = json["specific_warranty"];
    this.dropIn = json["drop_in"];
    this.homeVisit = json["home_visit"];
    this.pickUp = json["pick_up"];
    this.serviceHours = json["service_hours"];
    this.technicianServiceGroup = json["technician_service_group"];
    this.warranty = json["warranty"];
    this.warrantyDescription = json["warranty_description"];
    this.numPeriods = json["num_periods"];
    this.periodUnit = json["period_unit"];
    this.warrantyMonths = json["warranty_months"];
    this.roleId = json["role_id"];
    this.addressId = json["address_id"];
    this.email = json["email"];
    this.firstName = json["first_name"];
    this.middleName = json["middle_name"];
    this.lastName = json["last_name"];
    this.fullName = json["full_name"];
    this.gender = json["gender"];
    this.dateOfBirth = json["date_of_birth"];
    this.civilStatus = json["civil_status"];
    this.telephone = json["telephone"];
    this.telephone2 = json["telephone2"];
    this.fax = json["fax"];
    this.mobilePhone = json["mobile_phone"];
    this.employeeCode = json["employee_code"];
    this.jobTitle = json["job_title"];
    this.firstDateOfEmployment = json["first_date_of_employment"];
    this.lastDateOfEmployment = json["last_date_of_employment"];
    this.managerEmployeeCode = json["manager_employee_code"];
    this.lastLoginDatetime = json["last_login_datetime"];
    this.storeName = json["store_name"];
    this.bpStatus = json["bp_status"];
    var purchaseDate = DateFormat('yyyy-MM-dd').parse(this.purchaseDate!);
    var warrantyMonth = int.parse(this.warrantyMonths!);
    var warrantyDate = Jiffy(purchaseDate).add(months: warrantyMonth).dateTime;
    var warrantyPeriod = DateFormat('dd-MM-yyyy').format(
            DateFormat('yyyy-MM-dd').parse(this.purchaseDate!.toString())) +
        " - " +
        DateFormat('dd-MM-yyyy').format(warrantyDate);
    this.warrantyPeriod = warrantyPeriod;
    // warrantyPeriod += "-" + warrantyDate.
    var today = DateTime.now();
    var diff = warrantyDate.difference(today).inDays;

    this.statusCode = "0";
    this.status = "Expired";
    if (diff > 0) {
      this.status = "Active";
      this.statusCode = "1";
    }
    if (diff > 0 && diff < 61) {
      this.status = "Nearing Expiry";
      this.statusCode = "2";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["warranty_registration_id"] = this.warrantyRegistrationId;
    data["user_id"] = this.userId;
    data["product_id"] = this.productId;
    data["warranty_id"] = this.warrantyId;
    data["store_id"] = this.storeId;
    data["service_center_id"] = this.serviceCenterId;
    data["admin_approval_status_id"] = this.adminApprovalStatusId;
    data["purchase_date"] = this.purchaseDate;
    data["referral_code"] = this.referralCode;
    data["receipt_file"] = this.receiptFile;
    data["extended_warranty_id"] = this.extendedWarrantyId;
    data["serial_no"] = this.serialNo;
    data["is_send_sms_queue"] = this.isSendSmsQueue;
    data["sms_number"] = this.smsNumber;
    data["sms_sent_datetime"] = this.smsSentDatetime;
    data["i_dont_have_this_anymore"] = this.iDontHaveThisAnymore;
    data["inserted_at"] = this.insertedAt;
    data["updated_at"] = this.updatedAt;
    data["inserted_by"] = this.insertedBy;
    data["updated_by"] = this.updatedBy;
    data["admin_approval_status"] = this.adminApprovalStatus;
    data["description"] = this.description;
    data["extended_ewarranty_cost"] = this.extendedEwarrantyCost;
    data["product_group_id"] = this.productGroupId;
    data["product_model_id"] = this.productModelId;
    data["product_code"] = this.productCode;
    data["product_description"] = this.productDescription;
    data["product_group"] = this.productGroup;
    data["product_group_description"] = this.productGroupDescription;
    data["product_model"] = this.productModel;
    data["model_description"] = this.modelDescription;
    data["map_to_product_code"] = this.mapToProductCode;
    data["is_active"] = this.isActive;
    data["specific_warranty"] = this.specificWarranty;
    data["drop_in"] = this.dropIn;
    data["home_visit"] = this.homeVisit;
    data["pick_up"] = this.pickUp;
    data["service_hours"] = this.serviceHours;
    data["technician_service_group"] = this.technicianServiceGroup;
    data["warranty"] = this.warranty;
    data["warranty_description"] = this.warrantyDescription;
    data["num_periods"] = this.numPeriods;
    data["period_unit"] = this.periodUnit;
    data["warranty_months"] = this.warrantyMonths;
    data["role_id"] = this.roleId;
    data["address_id"] = this.addressId;
    data["email"] = this.email;
    data["first_name"] = this.firstName;
    data["middle_name"] = this.middleName;
    data["last_name"] = this.lastName;
    data["full_name"] = this.fullName;
    data["gender"] = this.gender;
    data["date_of_birth"] = this.dateOfBirth;
    data["civil_status"] = this.civilStatus;
    data["telephone"] = this.telephone;
    data["telephone2"] = this.telephone2;
    data["fax"] = this.fax;
    data["mobile_phone"] = this.mobilePhone;
    data["employee_code"] = this.employeeCode;
    data["job_title"] = this.jobTitle;
    data["first_date_of_employment"] = this.firstDateOfEmployment;
    data["last_date_of_employment"] = this.lastDateOfEmployment;
    data["manager_employee_code"] = this.managerEmployeeCode;
    data["last_login_datetime"] = this.lastLoginDatetime;
    data["store_name"] = this.storeName;
    data["bp_status"] = this.bpStatus;

    return data;
  }
}

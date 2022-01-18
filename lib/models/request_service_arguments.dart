import 'package:khind/models/ServiceCenter.dart';
import 'package:khind/models/service_problem.dart';
import 'package:khind/screens/service_type.dart';

import 'Purchase.dart';
import 'address.dart';

class RequestServiceArgument {
  RequestServiceArgument({
    required this.purchase,
    this.serviceCenter,
    this.serviceProblem,
    this.serviceRequestDate,
    this.serviceRequestTime,
    this.serviceType,
    this.address,
  });
  final Purchase purchase;
  final ServiceCenter? serviceCenter;
  final ServiceProblem? serviceProblem;
  final Address? address;
  final String? serviceRequestDate;
  final String? serviceRequestTime;
  final String? serviceType;
}

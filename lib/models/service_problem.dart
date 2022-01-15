class ServiceProblem {
  String? problemId;
  String? problemCode;
  String? problem;
  String? insertedAt;
  String? updatedAt;
  String? isReportedProblem;
  String? isExpectedProblem;
  String? isActualProblem;

  ServiceProblem(
      {this.problemId,
      this.problemCode,
      this.problem,
      this.insertedAt,
      this.updatedAt,
      this.isReportedProblem,
      this.isExpectedProblem,
      this.isActualProblem});

  ServiceProblem.fromJson(Map<String, dynamic> json) {
    this.problemId = json["problem_id"];
    this.problemCode = json["problem_code"];
    this.problem = json["problem"];
    this.insertedAt = json["inserted_at"];
    this.updatedAt = json["updated_at"];
    this.isReportedProblem = json["is_reported_problem"];
    this.isExpectedProblem = json["is_expected_problem"];
    this.isActualProblem = json["is_actual_problem"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["problem_id"] = this.problemId;
    data["problem_code"] = this.problemCode;
    data["problem"] = this.problem;
    data["inserted_at"] = this.insertedAt;
    data["updated_at"] = this.updatedAt;
    data["is_reported_problem"] = this.isReportedProblem;
    data["is_expected_problem"] = this.isExpectedProblem;
    data["is_actual_problem"] = this.isActualProblem;
    return data;
  }
}

class Beneficiary {
  final String name;
  final String nationalId;
  final String mobile;

  Beneficiary({
    required this.name,
    required this.nationalId,
    required this.mobile,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'national_id': nationalId,
    'mobile': mobile,
  };

  factory Beneficiary.fromJson(Map<String, dynamic> json) => Beneficiary(
    name: json['name']?.toString() ?? '',
    nationalId: json['national_id']?.toString() ?? json['id_number']?.toString() ?? '',
    mobile: json['mobile']?.toString() ?? json['phone']?.toString() ?? '',
  );
}

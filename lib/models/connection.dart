class Connection {
  final String type;
  Connection(this.type);
}

class OBSConnection extends Connection {
  final String ipAddress;
  final String port;
  final String password;

  OBSConnection({
    required this.ipAddress,
    required this.port,
    required this.password,
  }) : super('OBS');

  OBSConnection copyWith({
    String? ipAddress,
    String? port,
    String? password,
  }) {
    return OBSConnection(
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'ipAddress': ipAddress,
      'port': port,
      'password': password,
    };
  }

  factory OBSConnection.fromJson(Map<String, dynamic> json) {
    return OBSConnection(
      ipAddress: json['ipAddress'],
      port: json['port'],
      password: json['password'],
    );
  }
}

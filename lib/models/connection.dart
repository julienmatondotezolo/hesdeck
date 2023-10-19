class Connection {
  final String type;
  final String image;
  final bool connected;

  Connection(this.type, this.image, this.connected);

  Connection copyWith({required bool connected}) {
    return Connection(
      type,
      image,
      connected,
    );
  }
}

class OBSConnection extends Connection {
  final String ipAddress;
  final String port;
  final String password;

  OBSConnection({
    required this.ipAddress,
    required this.port,
    required this.password,
    bool connected = false, // Provide a default value for connected
  }) : super(
          'OBS',
          'https://obsproject.com/assets/images/new_icon_small-r.png',
          connected,
        );

  @override
  OBSConnection copyWith({
    String? ipAddress,
    String? port,
    String? password,
    required bool connected,
  }) {
    return OBSConnection(
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      password: password ?? this.password,
      connected: connected, // Update connected property
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'image': image,
      'connected': connected,
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
      connected: json['connected'],
    );
  }
}

class TwitchConnection extends Connection {
  final String clientId;
  final String port;
  final String password;

  TwitchConnection({
    required this.clientId,
    required this.port,
    required this.password,
    bool connected = false, // Provide a default value for connected
  }) : super(
          'Twitch',
          'https://cdn-icons-png.flaticon.com/512/2111/2111668.png',
          connected,
        );

  @override
  TwitchConnection copyWith({
    String? clientId,
    String? port,
    String? password,
    required bool connected,
  }) {
    return TwitchConnection(
      clientId: clientId ?? this.clientId,
      port: port ?? this.port,
      password: password ?? this.password,
      connected: connected, // Update connected property
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'image': image,
      'connected': connected,
      'clientId': clientId,
      'port': port,
      'password': password,
    };
  }

  factory TwitchConnection.fromJson(Map<String, dynamic> json) {
    return TwitchConnection(
      clientId: json['clientId'],
      port: json['port'],
      password: json['password'],
      connected: json['connected'],
    );
  }
}

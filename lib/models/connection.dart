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

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'image': image,
      'connected': connected,
    };
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

  @override
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
  final String username;
  final String password;

  TwitchConnection({
    required this.clientId,
    required this.username,
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
    String? username,
    String? password,
    required bool connected,
  }) {
    return TwitchConnection(
      clientId: clientId ?? this.clientId,
      username: username ?? this.username,
      password: password ?? this.password,
      connected: connected, // Update connected property
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'image': image,
      'connected': connected,
      'clientId': clientId,
      'username': username,
      'password': password,
    };
  }

  factory TwitchConnection.fromJson(Map<String, dynamic> json) {
    return TwitchConnection(
      clientId: json['clientId'],
      username: json['username'],
      password: json['password'],
      connected: json['connected'],
    );
  }
}

class SpotifyConnection extends Connection {
  final String clientId;
  final String clientSecret;
  SpotifyConnection({
    required this.clientId,
    required this.clientSecret,
    bool connected = false, // Provide a default value for connected
  }) : super(
          'Spotify',
          'https://cdn-icons-png.flaticon.com/512/174/174872.png',
          connected,
        );

  @override
  SpotifyConnection copyWith({
    String? clientId,
    String? clientSecret,
    required bool connected,
  }) {
    return SpotifyConnection(
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      connected: connected, // Update connected property
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'image': image,
      'connected': connected,
      'clientId': clientId,
      'clientSecret': clientSecret,
    };
  }

  factory SpotifyConnection.fromJson(Map<String, dynamic> json) {
    return SpotifyConnection(
      clientId: json['clientId'],
      clientSecret: json['clientSecret'],
      connected: json['connected'],
    );
  }
}

class StreamElementsConnection extends Connection {
  final String jwtToken;
  final String accounId;
  StreamElementsConnection({
    required this.jwtToken,
    required this.accounId,
    bool connected = false, // Provide a default value for connected
  }) : super(
          'StreamElements',
          'https://cdn.streamelements.com/static/logo/logo_red.png',
          connected,
        );

  @override
  StreamElementsConnection copyWith({
    String? jwtToken,
    String? accounId,
    required bool connected,
  }) {
    return StreamElementsConnection(
      jwtToken: jwtToken ?? this.jwtToken,
      accounId: accounId ?? this.accounId,
      connected: connected, // Update connected property
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'image': image,
      'connected': connected,
      'jwtToken': jwtToken,
      'accounId': accounId,
    };
  }

  factory StreamElementsConnection.fromJson(Map<String, dynamic> json) {
    return StreamElementsConnection(
      jwtToken: json['jwtToken'],
      accounId: json['accounId'],
      connected: json['connected'],
    );
  }
}

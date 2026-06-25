class RepLocation {
  const RepLocation({
    required this.userId,
    required this.fullName,
    required this.role,
    this.lat,
    this.lng,
    this.lastSeenAt,
  });

  final String   userId;
  final String   fullName;
  final String   role;
  final double?  lat;
  final double?  lng;
  final DateTime? lastSeenAt;

  factory RepLocation.fromJson(Map<String, dynamic> j) => RepLocation(
        userId:     j['userId'] as String,
        fullName:   j['fullName'] as String,
        role:       j['role'] as String,
        lat:        (j['lat'] as num?)?.toDouble(),
        lng:        (j['lng'] as num?)?.toDouble(),
        lastSeenAt: j['lastSeenAt'] == null ? null : DateTime.parse(j['lastSeenAt'] as String),
      );
}

class BootstrapConfig {
  const BootstrapConfig({
    required this.version,
    required this.maintenanceEnabled,
    required this.maintenanceMessage,
    required this.updateMode,
    required this.minBuild,
    required this.latestBuild,
    required this.storeUrl,
    required this.flags,
    required this.languages,
    required this.services,
    required this.cityName,
    required this.acceptTimeoutSec,
    this.supportPhone,
  });

  final int version;
  final bool maintenanceEnabled;
  final String? maintenanceMessage;
  final String updateMode; // none | optional | required
  final int minBuild;
  final int latestBuild;
  final String storeUrl;
  final Map<String, bool> flags;
  final List<String> languages;
  final List<ServiceTile> services;
  final String? cityName;
  final int acceptTimeoutSec;
  final String? supportPhone;

  factory BootstrapConfig.safeDefaults() => const BootstrapConfig(
        version: 0,
        maintenanceEnabled: false,
        maintenanceMessage: null,
        updateMode: 'none',
        minBuild: 0,
        latestBuild: 0,
        storeUrl: '',
        flags: {
          'wallet': false,
          'online_payments': false,
          'upi': false,
        },
        languages: ['en', 'te'],
        services: [
          ServiceTile(type: 'bike', name: 'Bike Ride', order: 1),
          ServiceTile(type: 'auto', name: 'Auto Ride', order: 2),
          ServiceTile(type: 'parcel', name: 'Parcel', order: 3),
          ServiceTile(type: 'logistics', name: 'Logistics', order: 4),
        ],
        cityName: null,
        acceptTimeoutSec: 15,
      );

  factory BootstrapConfig.fromJson(Map<String, dynamic> json) {
    final update = (json['update'] as Map?)?.cast<String, dynamic>() ?? {};
    final maintenance = (json['maintenance'] as Map?)?.cast<String, dynamic>() ?? {};
    final city = (json['city'] as Map?)?.cast<String, dynamic>();
    final servicesRaw = (city?['services'] as List?) ?? const [];
    final flags = ((json['flags'] as Map?) ?? {}).map(
      (k, v) => MapEntry(k.toString(), v == true),
    );
    final matching = (json['matchingHints'] as Map?)?.cast<String, dynamic>() ?? {};
    final support = (json['support'] as Map?)?.cast<String, dynamic>() ?? {};
    return BootstrapConfig(
      version: (json['version'] as num?)?.toInt() ?? 0,
      maintenanceEnabled: maintenance['enabled'] == true,
      maintenanceMessage: maintenance['message'] as String?,
      updateMode: (update['mode'] as String?) ?? 'none',
      minBuild: (update['minBuild'] as num?)?.toInt() ?? 0,
      latestBuild: (update['latestBuild'] as num?)?.toInt() ?? 0,
      storeUrl: (update['storeUrl'] as String?) ?? '',
      flags: flags,
      languages: ((json['languages'] as List?) ?? ['en', 'te']).map((e) => e.toString()).toList(),
      services: servicesRaw
          .whereType<Map>()
          .map((e) => ServiceTile.fromJson(e.cast<String, dynamic>()))
          .toList(),
      cityName: city?['name'] as String?,
      acceptTimeoutSec: (matching['acceptTimeoutSec'] as num?)?.toInt() ?? 15,
      supportPhone: support['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'maintenance': {'enabled': maintenanceEnabled, 'message': maintenanceMessage},
        'update': {
          'mode': updateMode,
          'minBuild': minBuild,
          'latestBuild': latestBuild,
          'storeUrl': storeUrl,
        },
        'flags': flags,
        'languages': languages,
        'city': {
          'name': cityName,
          'services': services.map((e) => e.toJson()).toList(),
        },
        'matchingHints': {'acceptTimeoutSec': acceptTimeoutSec},
        'support': {'phone': supportPhone},
      };
}

class ServiceTile {
  const ServiceTile({
    required this.type,
    required this.name,
    required this.order,
    this.iconUrl,
  });

  final String type;
  final String name;
  final int order;
  final String? iconUrl;

  factory ServiceTile.fromJson(Map<String, dynamic> json) => ServiceTile(
        type: json['type'] as String? ?? '',
        name: json['name'] as String? ?? '',
        order: (json['order'] as num?)?.toInt() ?? 0,
        iconUrl: json['iconUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'order': order,
        'iconUrl': iconUrl,
      };
}

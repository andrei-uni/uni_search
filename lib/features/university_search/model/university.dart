class University {
  const University({
    required this.name,
    required this.country,
    required this.url,
  });

  final String name;
  final String country;
  final String? url;

  @override
  bool operator ==(Object other) {
    return other is University && name == other.name && country == other.country && url == other.url;
  }

  @override
  int get hashCode {
    return Object.hash(name, country, url);
  }

  @override
  String toString() {
    return 'University(name: $name), country: $country, url: $url)';
  }
}

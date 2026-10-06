class HttpPagedResult {
  final int first;
  final dynamic prev;
  final int? next;
  final int last;
  final int pages;
  final int items;

  final List<dynamic> data;

  HttpPagedResult({
    required this.first,
    required this.prev,
    required this.next,
    required this.last,
    required this.pages,
    required this.items,
    required this.data,
  });

  factory HttpPagedResult.fromJson(
  Map<String, dynamic> json,
) {
  int? nullableInt(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return value;
    }

    return int.tryParse(
      value.toString(),
    );
  }

  int toInt(
    dynamic value, {
    int defaultValue = 0,
  }) {
    if (value == null) {
      return defaultValue;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(
          value.toString(),
        ) ??
        defaultValue;
  }

  return HttpPagedResult(
    first: toInt(
      json['first'],
      defaultValue: 1,
    ),

    prev: nullableInt(
      json['prev'],
    ),

    next: nullableInt(
      json['next'],
    ),

    last: toInt(
      json['last'],
      defaultValue: 1,
    ),

    pages: toInt(
      json['pages'],
      defaultValue: 1,
    ),

    items: toInt(
      json['items'],
    ),

    data: List<dynamic>.from(
      json['data'] ?? [],
    ),
  );
}
}
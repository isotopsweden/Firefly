enum Queries {
  isEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  arrayContains,
  arrayContainsAny,
  whereIn,
}

class Query {
  final String value;

  Query(this.value);

  late Queries method;
  dynamic comparer;

  isEqualTo(value) {
    method = Queries.isEqualTo;
    comparer = value;
  }

  isLessThan(value) {
    method = Queries.isLessThan;
    comparer = value;
  }

  isLessThanOrEqualTo(value) {
    method = Queries.isLessThanOrEqualTo;
    comparer = value;
  }

  isGreaterThan(value) {
    method = Queries.isGreaterThan;
    comparer = value;
  }

  isGreaterThanOrEqualTo(value) {
    method = Queries.isGreaterThanOrEqualTo;
    comparer = value;
  }

  arrayContains(value) {
    method = Queries.arrayContains;
    comparer = value;
  }

  arrayContainsAny(List<dynamic> value) {
    method = Queries.arrayContainsAny;
    comparer = value;
  }

  whereIn(List<dynamic> value) {
    method = Queries.whereIn;
    comparer = value;
  }
}

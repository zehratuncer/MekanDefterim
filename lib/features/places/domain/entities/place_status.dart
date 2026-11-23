/// Bir mekânın ziyaret durumunu temsil eder.
enum PlaceStatus {
  visited('visited', 'Gezildi'),
  planned('planned', 'Gitmek istiyorum');

  final String value;
  final String label;

  const PlaceStatus(this.value, this.label);

  static PlaceStatus fromString(String value) {
    return PlaceStatus.values.firstWhere(
      (element) => element.value == value,
      orElse: () => PlaceStatus.visited,
    );
  }
}

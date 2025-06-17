class FormatApp {
  /// Trả về [dd, MM, yyyy] từ 1 DateTime
  static List<String> formatDateDMY(DateTime dt) {
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yyyy = dt.year.toString(); // đầy đủ 4 chữ số
    return [dd, mm, yyyy];
  }
}

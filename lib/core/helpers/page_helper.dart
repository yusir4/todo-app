class PageHelper {
  String indexToPage(int index) {
    switch (index) {
      case 0:
        return 'Günlük Plan';
        break;
      case 1:
        return 'Haftalık Plan';
        break;
      case 2:
        return 'Aylık Plan';
        break;
      default:
        return 'Bilinmeyen';
    }
  }
}

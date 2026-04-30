import 'package:openfoodfacts/openfoodfacts.dart';

class OpenFoodFactorService {
  /// Cerca prodotti su OpenFoodFacts in base al nome
  Future<List<Product>> searchByNome(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return <Product>[];

    try {
      final config = ProductSearchQueryConfiguration(
        parametersList: [
          SearchTerms(terms: [trimmed]),
        ],
        fields: [
          ProductField.BARCODE,
          ProductField.NAME,
          ProductField.BRANDS,
          ProductField.NUTRIMENTS,
        ],
        language: OpenFoodAPIConfiguration.globalLanguages?.isNotEmpty == true
            ? OpenFoodAPIConfiguration.globalLanguages!.first
            : null,
        country: OpenFoodAPIConfiguration.globalCountry,
        version: ProductQueryVersion.v3,
      );

      final result = await OpenFoodAPIClient.searchProducts(null, config);
      return result.products ?? <Product>[];
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// Cerca prodotti su OpenFoodFacts in base al barcode
  Future<List<Product>> searchByCodiceBarre(String barcode) async {
    final trimmed = barcode.trim();
    if (trimmed.isEmpty) return <Product>[];

    try {
      final config = ProductQueryConfiguration(
        trimmed,
        fields: [
          ProductField.BARCODE,
          ProductField.NAME,
          ProductField.BRANDS,
          ProductField.NUTRIMENTS,
        ],
        language: OpenFoodAPIConfiguration.globalLanguages?.isNotEmpty == true
            ? OpenFoodAPIConfiguration.globalLanguages!.first
            : null,
        country: OpenFoodAPIConfiguration.globalCountry,
        version: ProductQueryVersion.v3,
      );

      final result = await OpenFoodAPIClient.getProductV3(config);
      return result.product == null ? <Product>[] : <Product>[result.product!];
    } catch (e) {
      throw Exception('$e');
    }
  }
}

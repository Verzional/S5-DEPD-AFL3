import 'package:depd_mvvm_2025/data/network/network_api_service.dart';
import 'package:depd_mvvm_2025/model/model.dart';

// Repository untuk menangani logika bisnis terkait data ongkir
class HomeRepository {
  // NetworkApiServices hanya perlu 1 instance sehingga tidak perlu ganti service selama aplikasi berjalan
  final _apiServices = NetworkApiServices();

  // Mengambil daftar provinsi dari API
  Future<List<Province>> fetchProvinceList() async {
    final response = await _apiServices.getApiResponse('destination/province');

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data provinsi
    final data = response['data'];
    if (data is! List) return [];

    // Ubah setiap item (Map) menjadi object Province
    return data.map((e) => Province.fromJson(e)).toList();
  }

  // Mengambil daftar kota berdasarkan ID provinsi
  Future<List<City>> fetchCityList(var provId) async {
    final response = await _apiServices.getApiResponse(
      'destination/city/$provId',
    );

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data kota
    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => City.fromJson(e)).toList();
  }

  // Menghitung biaya pengiriman berdasarkan parameter yang diberikan
  Future<List<Costs>> checkShipmentCost(
    String origin,
    String originType,
    String destination,
    String destinationType,
    int weight,
    String courier,
  ) async {
    // Kirim request POST untuk kalkulasi ongkir
    final response = await _apiServices
        .postApiResponse('calculate/district/domestic-cost', {
          "origin": origin,
          "destination": destination,
          "weight": weight.toString(),
          "courier": courier,
        });

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data biaya pengiriman
    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => Costs.fromJson(e)).toList();
  }

  // Mengambil daftar negara untuk pengiriman internasional
  Future<List<Country>> fetchCountryList() async {
    final response = await _apiServices.getApiResponse('destination/country');

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data negara
    final data = response['data'];
    if (data is! List) return [];

    // Ubah setiap item (Map) menjadi object Country
    return data.map((e) => Country.fromJson(e)).toList();
  }

  // Mencari destinasi internasional
  Future<List<InternationalDestination>> fetchInternationalDestination(String search) async {
    final response = await _apiServices.getApiResponse(
      'destination/international-destination?search=$search&limit=99&offset=0',
    );

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data
    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => InternationalDestination.fromJson(e)).toList();
  }

  // Menghitung biaya pengiriman internasional
  Future<List<Costs>> checkInternationalShipmentCost(
    String origin,
    String destination,
    int weight,
    String courier,
  ) async {
    // Kirim request POST untuk kalkulasi ongkir internasional
    final response = await _apiServices
        .postApiResponse('calculate/international-cost', {
          "origin": origin,
          "destination": destination,
          "weight": weight.toString(),
          "courier": courier,
          // "price": "lowest", // Optional: sort by price
        });

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data biaya pengiriman
    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => Costs.fromJson(e)).toList();
  }
}

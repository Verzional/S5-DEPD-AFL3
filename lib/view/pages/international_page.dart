part of 'pages.dart';

class InternationalPage extends StatefulWidget {
  const InternationalPage({super.key});

  @override
  State<InternationalPage> createState() => _InternationalPageState();
}

class _InternationalPageState extends State<InternationalPage> {
  late HomeViewModel homeViewModel;

  final weightController = TextEditingController();
  final searchController = TextEditingController();

  // Daftar pilihan kurir yang tersedia untuk internasional
  final List<String> courierOptions = ["pos", "tiki", "jne", "expedito"];
  String selectedCourier = "pos";

  // ID kota asal (domestik)
  int? selectedProvinceOriginId;
  int? selectedCityOriginId;

  // ID Destinasi Internasional
  int? selectedDestinationId;

  @override
  void initState() {
    super.initState();
    homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    if (homeViewModel.provinceList.status == Status.notStarted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        homeViewModel.getProvinceList();
      });
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Card untuk form input data pengiriman internasional
                Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Section pilihan kurir dan berat barang
                        Row(
                          children: [
                            // Dropdown pilihan kurir
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedCourier,
                                items: courierOptions
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c.toUpperCase()),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => setState(
                                  () => selectedCourier = v ?? "dhl",
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Input berat barang dalam gram
                            Expanded(
                              child: TextField(
                                controller: weightController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Berat (gr)',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Section Origin (Asal pengiriman domestik)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Origin (Domestic)",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            // Dropdown provinsi asal
                            Expanded(
                              child: Consumer<HomeViewModel>(
                                builder: (context, vm, _) {
                                  if (vm.provinceList.status == Status.loading) {
                                    return const SizedBox(
                                      height: 40,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  if (vm.provinceList.status == Status.error) {
                                    return Text(
                                      vm.provinceList.message ?? 'Error',
                                      style: const TextStyle(color: Colors.red),
                                    );
                                  }

                                  final provinces = vm.provinceList.data ?? [];
                                  if (provinces.isEmpty) {
                                    return const Text('Tidak ada provinsi');
                                  }

                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    value: selectedProvinceOriginId,
                                    hint: const Text('Pilih provinsi'),
                                    items: provinces
                                        .map(
                                          (p) => DropdownMenuItem(
                                            value: p.id,
                                            child: Text(p.name ?? ''),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (newId) {
                                      setState(() {
                                        selectedProvinceOriginId = newId;
                                        selectedCityOriginId = null;
                                      });
                                      if (newId != null) {
                                        vm.getCityOriginList(newId);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Dropdown kota asal
                            Expanded(
                              child: Consumer<HomeViewModel>(
                                builder: (context, vm, _) {
                                  if (vm.cityOriginList.status == Status.notStarted) {
                                    return const Text(
                                      'Pilih provinsi dulu',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    );
                                  }

                                  if (vm.cityOriginList.status == Status.loading) {
                                    return const SizedBox(
                                      height: 40,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  if (vm.cityOriginList.status == Status.error) {
                                    return Text(
                                      vm.cityOriginList.message ?? 'Error',
                                      style: const TextStyle(color: Colors.red),
                                    );
                                  }

                                  if (vm.cityOriginList.status == Status.completed) {
                                    final cities = vm.cityOriginList.data ?? [];

                                    if (cities.isEmpty) {
                                      return const Text(
                                        'Tidak ada kota',
                                      );
                                    }

                                    final validIds = cities
                                        .map((c) => c.id)
                                        .toSet();
                                    final validValue =
                                        validIds.contains(selectedCityOriginId)
                                        ? selectedCityOriginId
                                        : null;

                                    return DropdownButton<int>(
                                      isExpanded: true,
                                      value: validValue,
                                      hint: const Text('Pilih kota'),
                                      items: cities
                                          .map(
                                            (c) => DropdownMenuItem(
                                              value: c.id,
                                              child: Text(c.name ?? ''),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (newId) {
                                        setState(() => selectedCityOriginId = newId);
                                      },
                                    );
                                  }

                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Section Destination (Tujuan negara internasional)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Destination (International)",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                decoration: const InputDecoration(
                                  labelText: 'Cari Negara/Kota',
                                  hintText: 'Contoh: Malaysia, Jepang',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                if (searchController.text.isNotEmpty) {
                                  homeViewModel.getInternationalDestination(searchController.text);
                                  setState(() {
                                    selectedDestinationId = null;
                                  });
                                }
                              },
                              icon: const Icon(Icons.search),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Dropdown hasil search
                        Consumer<HomeViewModel>(
                          builder: (context, vm, _) {
                            if (vm.internationalDestinationList.status == Status.loading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (vm.internationalDestinationList.status == Status.error) {
                              return Text(vm.internationalDestinationList.message ?? "Error", style: const TextStyle(color: Colors.red));
                            }
                            if (vm.internationalDestinationList.status == Status.completed) {
                                final destinations = vm.internationalDestinationList.data ?? [];
                                if (destinations.isEmpty) return const Text("Tidak ditemukan");
                                
                                // Ensure selectedDestinationId exists in the items list
                                int? validValue = selectedDestinationId;
                                if (validValue != null && !destinations.any((e) => e.id == validValue)) {
                                  validValue = null;
                                }

                                return DropdownButton<int>(
                                  isExpanded: true,
                                  value: validValue,
                                  hint: const Text("Pilih Tujuan"),
                                  items: destinations.map((e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.name ?? "-"),
                                  )).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedDestinationId = val;
                                    });
                                  },
                                );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 12),
                        // Tombol untuk menghitung ongkir internasional
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Validasi semua field sudah terisi
                              if (selectedCityOriginId != null &&
                                  selectedDestinationId != null &&
                                  weightController.text.isNotEmpty &&
                                  selectedCourier.isNotEmpty) {
                                final weight =
                                    int.tryParse(weightController.text) ?? 0;
                                if (weight <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Berat harus lebih dari 0'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                  return;
                                }
                                // Panggil API untuk cek ongkir internasional
                                homeViewModel.checkInternationalShipmentCost(
                                  selectedCityOriginId!.toString(),
                                  selectedDestinationId!.toString(),
                                  weight,
                                  selectedCourier,
                                );
                              } else {
                                // Tampilkan pesan error jika ada field yang kosong
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Lengkapi semua field!'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.all(16),
                            ),
                            child: const Text(
                              "Hitung Ongkir Internasional",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Card untuk menampilkan hasil ongkir internasional
                Card(
                  color: Colors.blue[50],
                  elevation: 2,
                  child: Consumer<HomeViewModel>(
                    builder: (context, vm, _) {
                      // Tampilkan hasil sesuai status dari API
                      switch (vm.internationalCostList.status) {
                        case Status.loading:
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          );
                        case Status.error:
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                vm.internationalCostList.message ?? 'Error',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        case Status.completed:
                          if (vm.internationalCostList.data == null ||
                              vm.internationalCostList.data!.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text("Tidak ada data ongkir internasional."),
                              ),
                            );
                          }
                          // Tampilkan list ongkir dalam bentuk card
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: vm.internationalCostList.data?.length ?? 0,
                            itemBuilder: (context, index) => CardCost(
                              vm.internationalCostList.data!.elementAt(index),
                            ),
                          );
                        default:
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "Pilih kota asal, cari & pilih tujuan, lalu klik Hitung Ongkir Internasional.",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          // Overlay loading untuk proses background
          Consumer<HomeViewModel>(
            builder: (context, vm, _) {
              if (vm.isLoading) {
                return Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

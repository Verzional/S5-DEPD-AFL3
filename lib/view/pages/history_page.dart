part of 'pages.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, vm, _) {
          if (vm.historyList.isEmpty) {
            return const Center(
              child: Text('Belum ada riwayat pencarian'),
            );
          }

          return ListView.builder(
            itemCount: vm.historyList.length,
            itemBuilder: (context, index) {
              final history = vm.historyList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: history.type == "Domestic" ? Colors.blue[100] : Colors.orange[100],
                    child: Icon(
                      history.type == "Domestic" ? Icons.local_shipping : Icons.flight_takeoff,
                      color: history.type == "Domestic" ? Colors.blue : Colors.orange,
                    ),
                  ),
                  title: Text("${history.origin} -> ${history.destination}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Berat: ${history.weight}g | Kurir: ${history.courier.toUpperCase()}"),
                      Text(
                        DateFormat('dd MMM yyyy, HH:mm').format(history.timestamp),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: Text(
                    history.type,
                    style: TextStyle(
                      color: history.type == "Domestic" ? Colors.blue : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

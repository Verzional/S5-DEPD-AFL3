part of 'widgets.dart';

// Function to show bottom sheet with cost details
void showCostDetailsBottomSheet(BuildContext context, Costs cost) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Biaya Pengiriman',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Nama', cost.name ?? '-'),
            _buildDetailRow('Kode', cost.code ?? '-'),
            _buildDetailRow('Layanan', cost.service ?? '-'),
            _buildDetailRow('Deskripsi', cost.description ?? '-'),
            _buildDetailRow('Biaya', _formatCurrency(cost.cost)),
            _buildDetailRow('Estimasi', _formatEtd(cost.etd)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Helper function to build detail rows
Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    ),
  );
}

// Helper function to format currency
String _formatCurrency(int? value) {
  if (value == null) return 'Rp0,00';
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 2,
  );
  return formatter.format(value);
}

// Helper function to format ETD
String _formatEtd(String? etd) {
  if (etd == null || etd.isEmpty) return '-';
  return etd.replaceAll('day', 'hari').replaceAll('days', 'hari');
}


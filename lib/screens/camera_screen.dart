import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:parking_system/screens/afterscan_screen.dart';
import 'package:parking_system/controllers/activity_controller.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  Barcode? _barcode;
  bool _isScanned = false;
  bool _isProcessing = false;
  final MobileScannerController _controller = MobileScannerController();
  final ActivityController _activityController = ActivityController();

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (_isScanned || _isProcessing) return;

    final Barcode? code = barcodes.barcodes.firstOrNull;
    if (code != null && code.rawValue != null) {
      setState(() {
        _isScanned = true;
        _isProcessing = true;
        _barcode = code;
      });

      // Stop scanner
      await _controller.stop();

      try {
        // Show loading indicator
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text('Processing...'),
                ],
              ),
              duration: Duration(seconds: 30),
            ),
          );
        }

        // Post activity to backend - using the scanned QR code as user_id
        final ActivityResponse response = await _activityController.postActivity(
          code.rawValue!, // The scanned QR code should contain the user_id
        );

        if (!mounted) return;

        // Hide loading snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to AfterscanScreen with the returned activity ID
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => AfterscanScreen(
              activityId: response.activity.id, // Use the actual activity ID from response
            ),
          ),
        );
      } catch (e) {
        if (!mounted) return;

        // Hide loading snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );

        // Reset scanner state to allow retry
        setState(() {
          _isScanned = false;
          _isProcessing = false;
        });

        // Restart scanner
        await _controller.start();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: const Color(0xFF116692),
        foregroundColor: Colors.white,
        actions: [
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _handleBarcode,
          ),
          
          // Scanning overlay
          if (!_isScanned)
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF116692),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Position QR code within the frame',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          
          // Bottom info panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isProcessing)
                    const Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF116692)),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Processing activity...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Icon(
                          _isScanned ? Icons.check_circle : Icons.qr_code_scanner,
                          color: _isScanned ? Colors.green : const Color(0xFF116692),
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isScanned 
                            ? 'QR Code Scanned Successfully!' 
                            : 'Scan a QR code to check in/out',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_barcode?.displayValue != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Code: ${_barcode!.displayValue}',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ),
          
          // Retry button (shown only on error and when not processing)
          if (_isScanned && !_isProcessing)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      _isScanned = false;
                      _barcode = null;
                    });
                    await _controller.start();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Scan Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF116692),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
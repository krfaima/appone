// widgets/carpark_info_card.dart
import 'package:flutter/material.dart';
import '../models/carpark.dart';

class CarparkInfoCard extends StatelessWidget {
  final Carpark carpark;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  const CarparkInfoCard({
    Key? key,
    required this.carpark,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected
          ? (isDarkMode ? Colors.blueGrey[800] : Colors.blue[50])
          : (isDarkMode ? Colors.grey[850] : Colors.white),
      elevation: isSelected ? 4 : 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Colors.blue, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      carpark.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: carpark.availableSpots != null &&
                              carpark.availableSpots! > 10
                          ? Colors.green
                          : carpark.availableSpots != null &&
                                  carpark.availableSpots! > 0
                              ? Colors.orange
                              : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      carpark.availableSpots != null
                          ? '${carpark.availableSpots} spots'
                          : 'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (carpark.address != null)
                Text(
                  carpark.address!,
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${carpark.distanceFromUser.toStringAsFixed(1)} km away',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  Text(
                    carpark.price != null
                        ? '${carpark.price} €/hour'
                        : 'Price unknown',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

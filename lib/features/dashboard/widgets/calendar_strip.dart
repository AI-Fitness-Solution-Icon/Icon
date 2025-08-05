import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Scrollable calendar strip for date selection
class CalendarStrip extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const CalendarStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Further increased height to accommodate content
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: 14, // Show 2 weeks
        itemBuilder: (context, index) {
          final date = DateTime.now().subtract(Duration(days: 7 - index));
          final isSelected = _isSameDay(date, selectedDate);
          final isToday = _isSameDay(date, DateTime.now());
          
          return Container(
            margin: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => onDateSelected(date),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Prevent overflow
                children: [
                  // Day of week
                  Text(
                    _getDayAbbreviation(date.weekday),
                    style: TextStyle(
                      color: isSelected ? AppColors.textLight : AppColors.textSecondary,
                      fontSize: 11, // Reduced font size
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.visible, // Prevent text overflow
                  ),
                  const SizedBox(height: 6), // Reduced spacing
                  // Date circle
                  Container(
                    width: 36, // Reduced size
                    height: 36, // Reduced size
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected 
                          ? AppColors.primary 
                          : isToday 
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : Colors.transparent,
                      border: isToday && !isSelected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: isSelected 
                              ? AppColors.textLight 
                              : isToday 
                                  ? AppColors.primary
                                  : AppColors.textLight,
                          fontSize: 14, // Reduced font size
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.visible, // Prevent text overflow
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDayAbbreviation(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'M';
      case DateTime.tuesday:
        return 'T';
      case DateTime.wednesday:
        return 'W';
      case DateTime.thursday:
        return 'T';
      case DateTime.friday:
        return 'F';
      case DateTime.saturday:
        return 'S';
      case DateTime.sunday:
        return 'S';
      default:
        return '';
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
} 
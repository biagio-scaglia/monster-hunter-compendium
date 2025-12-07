import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FilterChipData {
  final String label;
  final String value;
  final IconData? icon;

  const FilterChipData({
    required this.label,
    required this.value,
    this.icon,
  });
}

class FilterChipBar extends StatefulWidget {
  final List<FilterChipData> filters;
  final List<String> selectedFilters;
  final ValueChanged<List<String>> onFiltersChanged;
  final bool multiSelect;

  const FilterChipBar({
    super.key,
    required this.filters,
    required this.selectedFilters,
    required this.onFiltersChanged,
    this.multiSelect = true,
  });

  @override
  State<FilterChipBar> createState() => _FilterChipBarState();
}

class _FilterChipBarState extends State<FilterChipBar> {
  late List<String> _selectedFilters;

  @override
  void initState() {
    super.initState();
    _selectedFilters = List.from(widget.selectedFilters);
  }

  @override
  void didUpdateWidget(FilterChipBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedFilters != oldWidget.selectedFilters) {
      _selectedFilters = List.from(widget.selectedFilters);
    }
  }

  void _toggleFilter(String value) {
    setState(() {
      if (widget.multiSelect) {
        if (_selectedFilters.contains(value)) {
          _selectedFilters.remove(value);
        } else {
          _selectedFilters.add(value);
        }
      } else {
        _selectedFilters = _selectedFilters.contains(value) ? [] : [value];
      }
      widget.onFiltersChanged(_selectedFilters);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: widget.filters.map((filter) {
          final isSelected = _selectedFilters.contains(filter.value);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: FilterChip(
                label: filter.icon != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            filter.icon,
                            size: 14,
                            color: isSelected ? AppTheme.primaryText : null,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              filter.label,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      )
                    : Text(
                        filter.label,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 12),
                      ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                selected: isSelected,
                onSelected: (_) => _toggleFilter(filter.value),
                selectedColor: AppTheme.primaryColor,
                checkmarkColor: AppTheme.primaryText,
                backgroundColor: Theme.of(context).cardColor,
                side: BorderSide(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : Colors.grey.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}


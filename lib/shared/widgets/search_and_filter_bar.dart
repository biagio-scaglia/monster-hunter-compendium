import 'package:flutter/material.dart';
import 'search_bar.dart';
import 'filter_chip_bar.dart';

class SearchAndFilterBar extends StatelessWidget {
  final String searchHint;
  final ValueChanged<String> onSearchChanged;
  final List<FilterChipData> filters;
  final List<String> selectedFilters;
  final ValueChanged<List<String>> onFiltersChanged;
  final bool showFilters;

  const SearchAndFilterBar({
    super.key,
    required this.onSearchChanged,
    required this.filters,
    required this.selectedFilters,
    required this.onFiltersChanged,
    this.searchHint = 'Search...',
    this.showFilters = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarWidget(
          hintText: searchHint,
          onSearchChanged: onSearchChanged,
        ),
        if (showFilters && filters.isNotEmpty)
          FilterChipBar(
            filters: filters,
            selectedFilters: selectedFilters,
            onFiltersChanged: onFiltersChanged,
          ),
      ],
    );
  }
}


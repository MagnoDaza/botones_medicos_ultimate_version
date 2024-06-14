import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';

import 'controller_expansion_panel.dart';

class CustomExpansionPanel extends StatelessWidget {
  final List<PanelItem> items;

  const CustomExpansionPanel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpansionPanelController>(
      builder: (context, model, child) {
        return SingleChildScrollView(
          child: ExpansionTileGroup(
            toggleType: ToggleType.expandAlwaysCurrent,
            spaceBetweenItem: 10.0,
            onExpansionItemChanged: (int index, bool isExpanded) {
              model.setExpandedIndex(isExpanded ? index : -1);
            },
            children: items.map<ExpansionTileItem>((PanelItem item) {
              int index = items.indexOf(item);
              return ExpansionTileItem(
                expandedAlignment: Alignment.center,
                title: Text(item.headerValue),
                leading: item.leading,
                initiallyExpanded: model.expandedIndex == index,
                isHasBottomBorder: false,
                isHasLeftBorder: false,
                isHasRightBorder: false,
                isHasTopBorder: false,
                children: item.expandedValue,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class PanelItem {
  final Widget? leading;
  final String headerValue;
  final List<Widget> expandedValue;

  PanelItem({
    required this.leading,
    required this.headerValue,
    required this.expandedValue,
  });
}

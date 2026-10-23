import 'package:flutter/material.dart';

import '../communication_colors.dart';
import '../communication_models.dart';
import '../communication_texts.dart';

/// Shows the sentence being built: words before + the picked card +
/// words after + "please". Each category decides which parts it uses.
class SelectionStrip extends StatelessWidget {
  const SelectionStrip({
    super.key,
    required this.category,
    required this.selectedItem,
    required this.isPolite,
    required this.onPoliteToggled,
  });

  final NeedCategory category;
  final NeedItem? selectedItem;
  final bool isPolite;
  final VoidCallback onPoliteToggled;

  static const double _radius = 24;
  static const double _borderWidth = 2;
  static const double _padding = 12;
  static const double _gap = 12;
  static const double _baseSlotHeight = 96;

  @override
  Widget build(BuildContext context) {
    final slotHeight = MediaQuery.textScalerOf(context).scale(_baseSlotHeight);
    final textStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(color: CommunicationColors.text);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(
          color: CommunicationColors.edge,
          width: _borderWidth,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: Row(
          children: [
            if (category.lead.isNotEmpty) ...[
              Text(category.lead, style: textStyle),
              const SizedBox(width: _gap),
            ],
            Expanded(
              child: _PickedCardSlot(item: selectedItem, height: slotHeight),
            ),
            if (category.tail.isNotEmpty) ...[
              const SizedBox(width: _gap),
              Text(category.tail, style: textStyle),
            ],
            if (category.canSayPlease) ...[
              const SizedBox(width: _gap),
              _PoliteButton(
                isSelected: isPolite,
                height: slotHeight,
                onTap: onPoliteToggled,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The box that shows the card the child picked.
class _PickedCardSlot extends StatelessWidget {
  const _PickedCardSlot({required this.item, required this.height});

  final NeedItem? item;
  final double height;

  static const double _radius = 16;
  static const double _emojiSize = 36;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pickedItem = item;

    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CommunicationColors.background,
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: pickedItem == null
          ? Text(
              CommunicationTexts.pickCard,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: CommunicationColors.text,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pickedItem.emoji,
                  style: const TextStyle(fontSize: _emojiSize),
                ),
                Text(
                  pickedItem.label,
                  style: textTheme.titleMedium?.copyWith(
                    color: CommunicationColors.text,
                  ),
                ),
              ],
            ),
    );
  }
}

/// The "please" toggle: tap to add or remove it from the sentence.
class _PoliteButton extends StatelessWidget {
  const _PoliteButton({
    required this.isSelected,
    required this.height,
    required this.onTap,
  });

  final bool isSelected;
  final double height;
  final VoidCallback onTap;

  static const double _radius = 16;
  static const double _borderWidth = 2;
  static const double _width = 84;
  static const double _emojiSize = 28;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(_radius);

    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: isSelected ? CommunicationColors.background : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(
            color: isSelected
                ? CommunicationColors.text
                : CommunicationColors.edge,
            width: _borderWidth,
          ),
        ),
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: SizedBox(
            width: _width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🙏', style: TextStyle(fontSize: _emojiSize)),
                Text(
                  CommunicationTexts.please,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: CommunicationColors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

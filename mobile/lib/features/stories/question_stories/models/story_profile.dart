/// The names the parents entered, shown inside the stories.
class StoryProfile {
  const StoryProfile({required this.childName, required this.friendName});

  static const String _childMarker = '{child}';
  static const String _friendMarker = '{friend}';

  final String childName;
  final String friendName;

  /// Replaces the `{child}` and `{friend}` markers of a story text with the
  /// real names. A text without markers comes back unchanged.
  String fill(String template) {
    return template
        .replaceAll(_childMarker, childName)
        .replaceAll(_friendMarker, friendName);
  }

  @override
  bool operator ==(Object other) {
    return other is StoryProfile &&
        other.childName == childName &&
        other.friendName == friendName;
  }

  @override
  int get hashCode => Object.hash(childName, friendName);
}

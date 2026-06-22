/// Dark Google Maps style for the Captain app (matches the dark theme). Keeps
/// place labels readable while muting the base so routes/markers stand out.
const String captainMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#11181f"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#8a99a6"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#0e141a"}]},
  {"featureType":"administrative","elementType":"geometry","stylers":[{"visibility":"off"}]},
  {"featureType":"poi","elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#16241b"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#263340"}]},
  {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9aa7b2"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#33414f"}]},
  {"featureType":"transit","stylers":[{"visibility":"off"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#0c2230"}]}
]
''';

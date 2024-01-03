// ignore_for_file: public_member_api_docs, sort_constructors_first

class Voice {
  late String name;
  late String locale;

  Voice({required this.name, required this.locale});

  Map<String, String> toMap() {
    return <String, String>{
      'name': name.toString(),
      'locale': locale.toString(),
    };
  }

  factory Voice.fromMap(Map<String, String> map) {
    return Voice(
        name: map['name'].toString(), locale: map['locale'].toString());
  }

  @override
  String toString() => 'Voice(name: $name, locale: $locale)';

  static Voice fromString(String s) {
    List<String> parts =
        s.replaceAll("Voice(", "").replaceAll(")", "").split(", ");

    var name = parts[0].split(": ")[1];
    var locale = parts[1].split(": ")[1];
    return Voice(name: name, locale: locale);
  }

  static List<Voice> parseVoicesList(String s) {
    // Remove brackets and split by '},'
    List<String> parts = s
        .replaceAll("[", "")
        .replaceAll("]", "")
        .split("},")
        .map((e) => e.trim())
        .toList();

    parts[parts.length - 1] = parts[parts.length - 1].split("}")[0];

    List<Voice> voicesList = parts.map((part) {
      // Remove braces, split by ',' and create a map
      Map<String, String> map = {
        for (var e in part.replaceAll("{", "").split(','))
          e.split(':')[0].trim(): e.split(':')[1].trim()
      };

      // Create Voices object from the map
      return Voice.fromMap(map);
    }).toList();

    return voicesList;
  }
}

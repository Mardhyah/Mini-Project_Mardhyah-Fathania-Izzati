class Juz {
  int? juz;
  int? juzStartSurahNumber;
  int? juzEndSurahNumber;
  String? juzStartInfo;
  String? juzEndInfo;
  int? totalVerses;
  List<Verses>? verses;

  Juz({
    this.juz,
    this.juzStartSurahNumber,
    this.juzEndSurahNumber,
    this.juzStartInfo,
    this.juzEndInfo,
    this.totalVerses,
    this.verses,
  });

  factory Juz.fromJson(Map<String, dynamic> json) {
    return Juz(
      juz: json['juz'] is int ? json['juz'] : int.parse(json['juz']),
      juzStartSurahNumber: json['juzStartSurahNumber'] is int
          ? json['juzStartSurahNumber']
          : int.parse(json['juzStartSurahNumber']),
      juzEndSurahNumber: json['juzEndSurahNumber'] is int
          ? json['juzEndSurahNumber']
          : int.parse(json['juzEndSurahNumber']),
      juzStartInfo: json['juzStartInfo'],
      juzEndInfo: json['juzEndInfo'],
      totalVerses: json['totalVerses'] is int
          ? json['totalVerses']
          : int.parse(json['totalVerses']),
      verses: json['verses'] != null
          ? List<Verses>.from(json['verses'].map((x) => Verses.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'juz': juz,
      'juzStartSurahNumber': juzStartSurahNumber,
      'juzEndSurahNumber': juzEndSurahNumber,
      'juzStartInfo': juzStartInfo,
      'juzEndInfo': juzEndInfo,
      'totalVerses': totalVerses,
      'verses': verses?.map((x) => x.toJson()).toList(),
    };
  }
}

class Verses {
  Number? number;
  Meta? meta;
  Text? text;
  Translation? translation;
  Audio? audio;
  Tafsir? tafsir;

  Verses({
    this.number,
    this.meta,
    this.text,
    this.translation,
    this.audio,
    this.tafsir,
  });

  factory Verses.fromJson(Map<String, dynamic> json) {
    return Verses(
      number: json['number'] != null ? Number.fromJson(json['number']) : null,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      text: json['text'] != null ? Text.fromJson(json['text']) : null,
      translation: json['translation'] != null
          ? Translation.fromJson(json['translation'])
          : null,
      audio: json['audio'] != null ? Audio.fromJson(json['audio']) : null,
      tafsir: json['tafsir'] != null ? Tafsir.fromJson(json['tafsir']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number?.toJson(),
      'meta': meta?.toJson(),
      'text': text?.toJson(),
      'translation': translation?.toJson(),
      'audio': audio?.toJson(),
      'tafsir': tafsir?.toJson(),
    };
  }
}

class Number {
  int? inQuran;
  int? inSurah;

  Number({
    this.inQuran,
    this.inSurah,
  });

  factory Number.fromJson(Map<String, dynamic> json) {
    return Number(
      inQuran:
          json['inQuran'] is int ? json['inQuran'] : int.parse(json['inQuran']),
      inSurah:
          json['inSurah'] is int ? json['inSurah'] : int.parse(json['inSurah']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inQuran': inQuran,
      'inSurah': inSurah,
    };
  }
}

class Meta {
  int? juz;
  int? page;
  int? manzil;
  int? ruku;
  int? hizbQuarter;
  Sajda? sajda;

  Meta({
    this.juz,
    this.page,
    this.manzil,
    this.ruku,
    this.hizbQuarter,
    this.sajda,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      juz: json['juz'] is int ? json['juz'] : int.parse(json['juz']),
      page: json['page'] is int ? json['page'] : int.parse(json['page']),
      manzil:
          json['manzil'] is int ? json['manzil'] : int.parse(json['manzil']),
      ruku: json['ruku'] is int ? json['ruku'] : int.parse(json['ruku']),
      hizbQuarter: json['hizbQuarter'] is int
          ? json['hizbQuarter']
          : int.parse(json['hizbQuarter']),
      sajda: json['sajda'] != null ? Sajda.fromJson(json['sajda']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'juz': juz,
      'page': page,
      'manzil': manzil,
      'ruku': ruku,
      'hizbQuarter': hizbQuarter,
      'sajda': sajda?.toJson(),
    };
  }
}

class Sajda {
  bool? recommended;
  bool? obligatory;

  Sajda({
    this.recommended,
    this.obligatory,
  });

  factory Sajda.fromJson(Map<String, dynamic> json) {
    return Sajda(
      recommended: json['recommended'],
      obligatory: json['obligatory'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recommended': recommended,
      'obligatory': obligatory,
    };
  }
}

class Text {
  String? arab;
  Transliteration? transliteration;

  Text({
    this.arab,
    this.transliteration,
  });

  factory Text.fromJson(Map<String, dynamic> json) {
    return Text(
      arab: json['arab'],
      transliteration: json['transliteration'] != null
          ? Transliteration.fromJson(json['transliteration'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arab': arab,
      'transliteration': transliteration?.toJson(),
    };
  }
}

class Transliteration {
  String? en;

  Transliteration({
    this.en,
  });

  factory Transliteration.fromJson(Map<String, dynamic> json) {
    return Transliteration(
      en: json['en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'en': en,
    };
  }
}

class Translation {
  String? en;
  String? id;

  Translation({
    this.en,
    this.id,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      en: json['en'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'en': en,
      'id': id,
    };
  }
}

class Audio {
  String? primary;
  List<String>? secondary;

  Audio({
    this.primary,
    this.secondary,
  });

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      primary: json['primary'],
      secondary: List<String>.from(json['secondary']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primary': primary,
      'secondary': secondary,
    };
  }
}

class Tafsir {
  Id? id;

  Tafsir({
    this.id,
  });

  factory Tafsir.fromJson(Map<String, dynamic> json) {
    return Tafsir(
      id: json['id'] != null ? Id.fromJson(json['id']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id?.toJson(),
    };
  }
}

class Id {
  String? short;
  String? long;

  Id({
    this.short,
    this.long,
  });

  factory Id.fromJson(Map<String, dynamic> json) {
    return Id(
      short: json['short'],
      long: json['long'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'short': short,
      'long': long,
    };
  }
}

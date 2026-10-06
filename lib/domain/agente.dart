/*import 'package:freezed_annotation/freezed_annotation.dart';


part 'agente.freezed.dart';

@freezed
abstract class Agente with _$Agente {
  const factory Agente  ({
    required String title,
    required int year,
    String? extract,
    String? imgUrl,
  }) = _Agente;
} */
int parseInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) {
    return value;
  }

  return int.tryParse(value.toString()) ?? 0;
  }
class Agente {
  
  final int id;
  final String name;
  final String slug;

  final Powerstats powerstats;
  final Appearance appearance;
  final HeroImages images;

  Agente({
    required this.id,
    required this.name,
    required this.slug,
    required this.powerstats,
    required this.appearance,
    required this.images,
  });

  factory Agente.fromJson(Map<String, dynamic> json) {
    return Agente(
      id: parseInt(json['id']),
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',

      powerstats: Powerstats.fromJson(
        json['powerstats'] ?? {},
      ),

      appearance: Appearance.fromJson(
        json['appearance'] ?? {},
      ),

      images: HeroImages.fromJson(
        json['images'] ?? {},
      ),
    );
  }
  Map<String, dynamic> toJson() {
  return {
    'id': id,
    'name': name,
    'slug': slug,

    'powerstats':
        powerstats.toJson(),

    'appearance':
        appearance.toJson(),

    'images':
        images.toJson(),
  };
}
  
  
}
class Powerstats {
    final int intelligence;
    final int strength;
    final int speed;
    final int durability;
    final int power;
    final int combat;

  Powerstats({
    required this.intelligence,
    required this.strength,
    required this.speed,
    required this.durability,
    required this.power,
    required this.combat,
  });

  factory Powerstats.fromJson(Map<String, dynamic> json) {
    return Powerstats(
      intelligence: json['intelligence'] ?? 0,
      strength: json['strength'] ?? 0,
      speed: json['speed'] ?? 0,
      durability: json['durability'] ?? 0,
      power: json['power'] ?? 0,
      combat: json['combat'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
  return {
    'intelligence': intelligence,
    'strength': strength,
    'speed': speed,
    'durability': durability,
    'power': power,
    'combat': combat,
  };
}
}
class Appearance {
  final String gender;
  final String race;

  final List<String> height;
  final List<String> weight;

  final String eyeColor;
  final String hairColor;

  Appearance({
    required this.gender,
    required this.race,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hairColor,
  });

  factory Appearance.fromJson(Map<String, dynamic> json) {
    return Appearance(
      gender: json['gender'] ?? '',
      race: json['race'] ?? 'Unknown',

      height: List<String>.from(
        json['height'] ?? [],
      ),

      weight: List<String>.from(
        json['weight'] ?? [],
      ),

      eyeColor: json['eyeColor'] ?? '',
      hairColor: json['hairColor'] ?? '',
    );
  } 
  Map<String, dynamic> toJson() {
  return {
    'gender': gender,
    'race': race,
    'height': height,
    'weight': weight,
    'eyeColor': eyeColor,
    'hairColor': hairColor,
  };
}
} 
class HeroImages {
  final String xs;
  final String sm;
  final String md;
  final String lg;

  HeroImages({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
  });

  factory HeroImages.fromJson(Map<String, dynamic> json) {
    return HeroImages(
      xs: json['xs'] ?? '',
      sm: json['sm'] ?? '',
      md: json['md'] ?? '',
      lg: json['lg'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
  return {
    'xs': xs,
    'sm': sm,
    'md': md,
    'lg': lg,
  };
}
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentModel _$ContentModelFromJson(Map<String, dynamic> json) => ContentModel(
  id: json['id'] as String,
  title: json['title'] as String,
  type: json['type'] as String,
  synopsis: json['synopsis'] as String,
  posterUrl: json['poster_url'] as String,
  backdropUrl: json['backdrop_url'] as String,
  releaseYear: (json['release_year'] as num).toInt(),
  genres: (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
  rating: (json['rating'] as num).toDouble(),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  streamUrl: json['stream_url'] as String?,
  seasonCount: (json['season_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$ContentModelToJson(ContentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'synopsis': instance.synopsis,
      'poster_url': instance.posterUrl,
      'backdrop_url': instance.backdropUrl,
      'release_year': instance.releaseYear,
      'genres': instance.genres,
      'rating': instance.rating,
      'duration_minutes': instance.durationMinutes,
      'stream_url': instance.streamUrl,
      'season_count': instance.seasonCount,
    };

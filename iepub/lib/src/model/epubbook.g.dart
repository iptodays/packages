// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epubbook.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetEpubBookCollection on Isar {
  IsarCollection<EpubBook> get epubBooks => this.collection();
}

const EpubBookSchema = CollectionSchema(
  name: r'EpubBook',
  id: 5393310211404807579,
  properties: {
    r'chapters': PropertySchema(
      id: 0,
      name: r'chapters',
      type: IsarType.objectList,
      target: r'EpubChapter',
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.string,
    )
  },
  estimateSize: _epubBookEstimateSize,
  serialize: _epubBookSerialize,
  deserialize: _epubBookDeserialize,
  deserializeProp: _epubBookDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {r'EpubChapter': EpubChapterSchema},
  getId: _epubBookGetId,
  getLinks: _epubBookGetLinks,
  attach: _epubBookAttach,
  version: '3.0.2',
);

int _epubBookEstimateSize(
  EpubBook object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.chapters.length * 3;
  {
    final offsets = allOffsets[EpubChapter]!;
    for (var i = 0; i < object.chapters.length; i++) {
      final value = object.chapters[i];
      bytesCount += EpubChapterSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.id.length * 3;
  return bytesCount;
}

void _epubBookSerialize(
  EpubBook object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<EpubChapter>(
    offsets[0],
    allOffsets,
    EpubChapterSchema.serialize,
    object.chapters,
  );
  writer.writeString(offsets[1], object.id);
}

EpubBook _epubBookDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EpubBook(
    chapters: reader.readObjectList<EpubChapter>(
          offsets[0],
          EpubChapterSchema.deserialize,
          allOffsets,
          EpubChapter(),
        ) ??
        [],
    id: reader.readString(offsets[1]),
  );
  return object;
}

P _epubBookDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<EpubChapter>(
            offset,
            EpubChapterSchema.deserialize,
            allOffsets,
            EpubChapter(),
          ) ??
          []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _epubBookGetId(EpubBook object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _epubBookGetLinks(EpubBook object) {
  return [];
}

void _epubBookAttach(IsarCollection<dynamic> col, Id id, EpubBook object) {}

extension EpubBookQueryWhereSort on QueryBuilder<EpubBook, EpubBook, QWhere> {
  QueryBuilder<EpubBook, EpubBook, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EpubBookQueryWhere on QueryBuilder<EpubBook, EpubBook, QWhereClause> {
  QueryBuilder<EpubBook, EpubBook, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EpubBookQueryFilter
    on QueryBuilder<EpubBook, EpubBook, QFilterCondition> {
  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> chaptersLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapters',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> chaptersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapters',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> chaptersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapters',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition>
      chaptersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapters',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition>
      chaptersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapters',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> chaptersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapters',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EpubBookQueryObject
    on QueryBuilder<EpubBook, EpubBook, QFilterCondition> {
  QueryBuilder<EpubBook, EpubBook, QAfterFilterCondition> chaptersElement(
      FilterQuery<EpubChapter> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'chapters');
    });
  }
}

extension EpubBookQueryLinks
    on QueryBuilder<EpubBook, EpubBook, QFilterCondition> {}

extension EpubBookQuerySortBy on QueryBuilder<EpubBook, EpubBook, QSortBy> {
  QueryBuilder<EpubBook, EpubBook, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension EpubBookQuerySortThenBy
    on QueryBuilder<EpubBook, EpubBook, QSortThenBy> {
  QueryBuilder<EpubBook, EpubBook, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<EpubBook, EpubBook, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }
}

extension EpubBookQueryWhereDistinct
    on QueryBuilder<EpubBook, EpubBook, QDistinct> {
  QueryBuilder<EpubBook, EpubBook, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }
}

extension EpubBookQueryProperty
    on QueryBuilder<EpubBook, EpubBook, QQueryProperty> {
  QueryBuilder<EpubBook, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<EpubBook, List<EpubChapter>, QQueryOperations>
      chaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapters');
    });
  }

  QueryBuilder<EpubBook, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }
}

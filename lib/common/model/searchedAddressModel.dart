import 'dart:convert';

class SearchedAddressModel {
  String mainName;
  String secondaryName;
  String placeID;

  SearchedAddressModel({
    required this.mainName,
    required this.secondaryName,
    required this.placeID,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mainName': mainName,
      'secondaryName': secondaryName,
      'placeID': placeID,
    };
  }

  factory SearchedAddressModel.fromMap(Map<String, dynamic> map) {
    return SearchedAddressModel(
      mainName: map['mainName'] as String,
      secondaryName: map['secondaryName'] as String,
      placeID: map['placeID'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchedAddressModel.fromJson(String source) => SearchedAddressModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

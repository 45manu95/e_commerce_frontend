class ImageData {
  final String name;
  final String type;
  final String picByte;

  ImageData({
    required this.name,
    required this.type,
    required this.picByte,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      name: json['name'],
      type: json['type'],
      picByte: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'content': picByte,
    };
  }
}
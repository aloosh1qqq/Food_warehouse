class ImageModle {
  String url;
  ImageModle({required this.url});

  Map<String, dynamic> toJson() => {
        'url': url,
      };
}

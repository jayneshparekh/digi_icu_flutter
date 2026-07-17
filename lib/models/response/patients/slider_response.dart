class SliderResponse {
  final String status;
  final List<SliderItem> homeSlider;
  final List<SliderItem> awarenessSlider;
  final List<TextSliderItem> textSlider;

  SliderResponse({
    required this.status,
    required this.homeSlider,
    required this.awarenessSlider,
    required this.textSlider,
  });

  factory SliderResponse.fromJson(Map<String, dynamic> json) {
    var homeList = json['home_slider'] as List?;
    var awarenessList = json['awareness_slider'] as List?;
    var textList = json['text_slider'] as List?;

    return SliderResponse(
      status: json['status']?.toString() ?? '',
      homeSlider: homeList != null
          ? homeList.map((i) => SliderItem.fromJson(i)).toList()
          : [],
      awarenessSlider: awarenessList != null
          ? awarenessList.map((i) => SliderItem.fromJson(i)).toList()
          : [],
      textSlider: textList != null
          ? textList.map((i) => TextSliderItem.fromJson(i)).toList()
          : [],
    );
  }
}

class SliderItem {
  final String image;
  final String redirectTo;

  SliderItem({
    required this.image,
    required this.redirectTo,
  });

  factory SliderItem.fromJson(Map<String, dynamic> json) {
    return SliderItem(
      image: json['image']?.toString() ?? '',
      redirectTo: json['redirect_to']?.toString() ?? '',
    );
  }
}

class TextSliderItem {
  final String textMsg;
  final String redirectTo;

  TextSliderItem({
    required this.textMsg,
    required this.redirectTo,
  });

  factory TextSliderItem.fromJson(Map<String, dynamic> json) {
    return TextSliderItem(
      textMsg: json['text_msg']?.toString() ?? '',
      redirectTo: json['redirect_to']?.toString() ?? '',
    );
  }
}


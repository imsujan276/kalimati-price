class Product {
  Meta meta;
  List<Result> result;

  Product({this.meta, this.result});

  Product.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  String name;
  String license;
  String website;

  Meta({this.name, this.license, this.website});

  Meta.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    license = json['license'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['license'] = this.license;
    data['website'] = this.website;
    return data;
  }
}

class Result {
  int id;
  String commodityName;
  List<RetailPrice> retailPrice;
  List<WholesalePrice> wholesalePrice;

  Result({this.id, this.commodityName, this.retailPrice, this.wholesalePrice});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commodityName = json['commodityName'];
    if (json['retailPrice'] != null) {
      retailPrice = new List<RetailPrice>();
      json['retailPrice'].forEach((v) {
        retailPrice.add(new RetailPrice.fromJson(v));
      });
    }
    if (json['wholesalePrice'] != null) {
      wholesalePrice = new List<WholesalePrice>();
      json['wholesalePrice'].forEach((v) {
        wholesalePrice.add(new WholesalePrice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['commodityName'] = this.commodityName;
    if (this.retailPrice != null) {
      data['retailPrice'] = this.retailPrice.map((v) => v.toJson()).toList();
    }
    if (this.wholesalePrice != null) {
      data['wholesalePrice'] =
          this.wholesalePrice.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RetailPrice {
  String unit;
  int min;
  int max;
  int avg;
  String date;

  RetailPrice({this.unit, this.min, this.max, this.avg, this.date});

  RetailPrice.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    min = json['min'];
    max = json['max'];
    avg = json['avg'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unit'] = this.unit;
    data['min'] = this.min;
    data['max'] = this.max;
    data['avg'] = this.avg;
    data['date'] = this.date;
    return data;
  }
}


class WholesalePrice {
  String unit;
  int min;
  int max;
  int avg;
  String date;

  WholesalePrice({this.unit, this.min, this.max, this.avg, this.date});

  WholesalePrice.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    min = json['min'];
    max = json['max'];
    avg = json['avg'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unit'] = this.unit;
    data['min'] = this.min;
    data['max'] = this.max;
    data['avg'] = this.avg;
    data['date'] = this.date;
    return data;
  }
}

class FeildItem {
  String fname;
  String ftype;
  String fvalue;

  FeildItem({
    this.fname,
    this.ftype,
    this.fvalue,
  });

  factory FeildItem.fromJson(Map<String, dynamic> json) {
    return new FeildItem(
      fname: json['fname'],
      ftype: json['ftype'],
      fvalue: json['fvalue'],
    );
  }
}

class cache {
  int id;
  String name;
  String data;
  String LastEditDateTime;
  cache({
    this.id,
    this.name,
    this.data,
    this.LastEditDateTime,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'data': data,
      'LastEditDateTime': LastEditDateTime,
    };
  }
}

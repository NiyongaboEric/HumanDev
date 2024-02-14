class Group implements Comparable<Group> {
  final int? id;
  final String? name;
  final bool? isRole;
  final bool? isActive;
  final int? spaceId;

  const Group({
    this.id,
    this.name,
    this.isRole,
    this.isActive,
    this.spaceId,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      isRole: json['isRole'],
      isActive: json['isActive'],
      spaceId: json['spaceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isRole': isRole,
      'isActive': isActive,
      'spaceId': spaceId,
    };
  }
  
  @override
  int compareTo(Group other) {    
    // TODO: implement compareTo    
    // Compare by isRole and then by name
    if (this.isRole == other.isRole) {
      return this.name!.compareTo(other.name!);
    } else {
      return this.isRole! ? -1 : 1;
    }

  }
}
import 'dart:convert';

List<Topic> topics = [];
List<Topic> lifeTVTopics = [];

List<Topic> topicFromJson(String str) =>
    List<Topic>.from(json.decode(str).map((x) => Topic.fromJson(x)));

String topicToJson(List<Topic> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Topic {
  String? id;
  String? slug;
  String? title;
  String? description;
  String? publishedAt;
  String? updatedAt;
  String? startsAt;
  String? endsAt;
  bool? onlySubmissionsAfter;
  bool? featured;
  int? totalPhotos;
  List<String>? currentUserContributions;
  int? totalCurrentUserSubmissions;
  Links3? links;
  String? status;
  List<Owners>? owners;
  CoverPhoto? coverPhoto;
  List<PreviewPhotos>? previewPhotos;

  Topic(
      {this.id,
      this.slug,
      this.title,
      this.description,
      this.publishedAt,
      this.updatedAt,
      this.startsAt,
      this.endsAt,
      this.onlySubmissionsAfter,
      this.featured,
      this.totalPhotos,
      this.currentUserContributions,
      this.totalCurrentUserSubmissions,
      this.links,
      this.status,
      this.owners,
      this.coverPhoto,
      this.previewPhotos});

  Topic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    title = json['title'];
    description = json['description'];
    publishedAt = json['published_at'];
    updatedAt = json['updated_at'];
    startsAt = json['starts_at'];
    endsAt = json['ends_at'];
    onlySubmissionsAfter = json['only_submissions_after'];
    featured = json['featured'];
    totalPhotos = json['total_photos'];
    if (json['current_user_contributions'] != null) {
      currentUserContributions = [];
      json['current_user_contributions'].forEach((v) {
        currentUserContributions!.add(jsonDecode(v));
      });
    }
    totalCurrentUserSubmissions = json['total_current_user_submissions'];
    links = json['links'] != null ? Links3.fromJson(json['links']) : null;
    status = json['status'];
    if (json['owners'] != null) {
      owners = <Owners>[];
      json['owners'].forEach((v) {
        owners!.add(Owners.fromJson(v));
      });
    }
    coverPhoto = json['cover_photo'] != null
        ? CoverPhoto.fromJson(json['cover_photo'])
        : null;
    if (json['preview_photos'] != null) {
      previewPhotos = <PreviewPhotos>[];
      json['preview_photos'].forEach((v) {
        previewPhotos!.add(PreviewPhotos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['description'] = description;
    data['published_at'] = publishedAt;
    data['updated_at'] = updatedAt;
    data['starts_at'] = startsAt;
    data['ends_at'] = endsAt;
    data['only_submissions_after'] = onlySubmissionsAfter;
    data['featured'] = featured;
    data['total_photos'] = totalPhotos;
    if (currentUserContributions != null) {
      data['current_user_contributions'] =
          currentUserContributions!.map((v) => jsonDecode(v)).toList();
    }
    data['total_current_user_submissions'] = totalCurrentUserSubmissions;
    if (links != null) {
      data['links'] = links!.toJson();
    }
    data['status'] = status;
    if (owners != null) {
      data['owners'] = owners!.map((v) => v.toJson()).toList();
    }
    if (coverPhoto != null) {
      data['cover_photo'] = coverPhoto!.toJson();
    }
    if (previewPhotos != null) {
      data['preview_photos'] = previewPhotos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Links3 {
  String? self;
  String? html;
  String? photos;

  Links3({this.self, this.html, this.photos});

  Links3.fromJson(Map<String, dynamic> json) {
    self = json['self'];
    html = json['html'];
    photos = json['photos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['self'] = self;
    data['html'] = html;
    data['photos'] = photos;
    return data;
  }
}

class Owners {
  String? id;
  String? updatedAt;
  String? username;
  String? name;
  String? firstName;
  String? lastName;
  String? twitterUsername;
  String? portfolioUrl;
  String? bio;
  String? location;
  Links1? links;
  ProfileImage? profileImage;
  String? instagramUsername;
  int? totalCollections;
  int? totalLikes;
  int? totalPhotos;
  bool? acceptedTos;
  bool? forHire;
  Social? social;

  Owners(
      {this.id,
      this.updatedAt,
      this.username,
      this.name,
      this.firstName,
      this.lastName,
      this.twitterUsername,
      this.portfolioUrl,
      this.bio,
      this.location,
      this.links,
      this.profileImage,
      this.instagramUsername,
      this.totalCollections,
      this.totalLikes,
      this.totalPhotos,
      this.acceptedTos,
      this.forHire,
      this.social});

  Owners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    updatedAt = json['updated_at'];
    username = json['username'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    twitterUsername = json['twitter_username'];
    portfolioUrl = json['portfolio_url'];
    bio = json['bio'];
    location = json['location'];
    links = json['links'] != null ? Links1.fromJson(json['links']) : null;
    profileImage = json['profile_image'] != null
        ? ProfileImage.fromJson(json['profile_image'])
        : null;
    instagramUsername = json['instagram_username'];
    totalCollections = json['total_collections'];
    totalLikes = json['total_likes'];
    totalPhotos = json['total_photos'];
    acceptedTos = json['accepted_tos'];
    forHire = json['for_hire'];
    social = json['social'] != null ? Social.fromJson(json['social']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['updated_at'] = updatedAt;
    data['username'] = username;
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['twitter_username'] = twitterUsername;
    data['portfolio_url'] = portfolioUrl;
    data['bio'] = bio;
    data['location'] = location;
    if (links != null) {
      data['links'] = links!.toJson();
    }
    if (profileImage != null) {
      data['profile_image'] = profileImage!.toJson();
    }
    data['instagram_username'] = instagramUsername;
    data['total_collections'] = totalCollections;
    data['total_likes'] = totalLikes;
    data['total_photos'] = totalPhotos;
    data['accepted_tos'] = acceptedTos;
    data['for_hire'] = forHire;
    if (social != null) {
      data['social'] = social!.toJson();
    }
    return data;
  }
}

class Links1 {
  String? self;
  String? html;
  String? photos;
  String? likes;
  String? portfolio;
  String? following;
  String? followers;

  Links1(
      {this.self,
      this.html,
      this.photos,
      this.likes,
      this.portfolio,
      this.following,
      this.followers});

  Links1.fromJson(Map<String, dynamic> json) {
    self = json['self'];
    html = json['html'];
    photos = json['photos'];
    likes = json['likes'];
    portfolio = json['portfolio'];
    following = json['following'];
    followers = json['followers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['self'] = self;
    data['html'] = html;
    data['photos'] = photos;
    data['likes'] = likes;
    data['portfolio'] = portfolio;
    data['following'] = following;
    data['followers'] = followers;
    return data;
  }
}

class ProfileImage {
  String? small;
  String? medium;
  String? large;

  ProfileImage({this.small, this.medium, this.large});

  ProfileImage.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    medium = json['medium'];
    large = json['large'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['small'] = small;
    data['medium'] = medium;
    data['large'] = large;
    return data;
  }
}

class Social {
  String? instagramUsername;
  String? portfolioUrl;
  String? twitterUsername;
  String? paypalEmail;

  Social(
      {this.instagramUsername,
      this.portfolioUrl,
      this.twitterUsername,
      this.paypalEmail});

  Social.fromJson(Map<String, dynamic> json) {
    instagramUsername = json['instagram_username'];
    portfolioUrl = json['portfolio_url'];
    twitterUsername = json['twitter_username'];
    paypalEmail = json['paypal_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instagram_username'] = instagramUsername;
    data['portfolio_url'] = portfolioUrl;
    data['twitter_username'] = twitterUsername;
    data['paypal_email'] = paypalEmail;
    return data;
  }
}

class CoverPhoto {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? promotedAt;
  int? width;
  int? height;
  String? color;
  String? blurHash;
  String? description;
  String? altDescription;
  Urls? urls;
  Links2? links;
  List<String>? categories;
  int? likes;
  bool? likedByUser;
  List<String>? currentUserCollections;
  String? sponsorship;
  TopicSubmissions? topicSubmissions;
  User? user;

  CoverPhoto(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.promotedAt,
      this.width,
      this.height,
      this.color,
      this.blurHash,
      this.description,
      this.altDescription,
      this.urls,
      this.links,
      this.categories,
      this.likes,
      this.likedByUser,
      this.currentUserCollections,
      this.sponsorship,
      this.topicSubmissions,
      this.user});

  CoverPhoto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    promotedAt = json['promoted_at'];
    width = json['width'];
    height = json['height'];
    color = json['color'];
    blurHash = json['blur_hash'];
    description = json['description'];
    altDescription = json['alt_description'];
    urls = json['urls'] != null ? Urls.fromJson(json['urls']) : null;
    links = json['links'] != null ? Links2.fromJson(json['links']) : null;
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories!.add(jsonDecode(v));
      });
    }
    likes = json['likes'];
    likedByUser = json['liked_by_user'];
    if (json['current_user_collections'] != null) {
      currentUserCollections = [];
      json['current_user_collections'].forEach((v) {
        currentUserCollections!.add(jsonDecode(v));
      });
    }
    sponsorship = json['sponsorship'] is String ? json['sponsorship'] : null;
    topicSubmissions = json['topic_submissions'] != null
        ? TopicSubmissions.fromJson(json['topic_submissions'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['promoted_at'] = promotedAt;
    data['width'] = width;
    data['height'] = height;
    data['color'] = color;
    data['blur_hash'] = blurHash;
    data['description'] = description;
    data['alt_description'] = altDescription;
    if (urls != null) {
      data['urls'] = urls!.toJson();
    }
    if (links != null) {
      data['links'] = links!.toJson();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => jsonEncode(v)).toList();
    }
    data['likes'] = likes;
    data['liked_by_user'] = likedByUser;
    if (currentUserCollections != null) {
      data['current_user_collections'] =
          currentUserCollections!.map((v) => jsonEncode(v)).toList();
    }
    data['sponsorship'] = sponsorship;
    if (topicSubmissions != null) {
      data['topic_submissions'] = topicSubmissions!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Urls {
  String? raw;
  String? full;
  String? regular;
  String? small;
  String? thumb;
  String? smallS3;

  Urls(
      {this.raw,
      this.full,
      this.regular,
      this.small,
      this.thumb,
      this.smallS3});

  Urls.fromJson(Map<String, dynamic> json) {
    raw = json['raw'];
    full = json['full'];
    regular = json['regular'];
    small = json['small'];
    thumb = json['thumb'];
    smallS3 = json['small_s3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['raw'] = raw;
    data['full'] = full;
    data['regular'] = regular;
    data['small'] = small;
    data['thumb'] = thumb;
    data['small_s3'] = smallS3;
    return data;
  }
}

class Links2 {
  String? self;
  String? html;
  String? download;
  String? downloadLocation;

  Links2({this.self, this.html, this.download, this.downloadLocation});

  Links2.fromJson(Map<String, dynamic> json) {
    self = json['self'];
    html = json['html'];
    download = json['download'];
    downloadLocation = json['download_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['self'] = self;
    data['html'] = html;
    data['download'] = download;
    data['download_location'] = downloadLocation;
    return data;
  }
}

class TopicSubmissions {
  Entrepreneur? entrepreneur;
  Entrepreneur? backToSchool;

  TopicSubmissions({this.entrepreneur, this.backToSchool});

  TopicSubmissions.fromJson(Map<String, dynamic> json) {
    entrepreneur = json['entrepreneur'] != null
        ? Entrepreneur.fromJson(json['entrepreneur'])
        : null;
    backToSchool = json['back-to-school'] != null
        ? Entrepreneur.fromJson(json['back-to-school'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (entrepreneur != null) {
      data['entrepreneur'] = entrepreneur!.toJson();
    }
    if (backToSchool != null) {
      data['back-to-school'] = backToSchool!.toJson();
    }
    return data;
  }
}

class Entrepreneur {
  String? status;
  String? approvedOn;

  Entrepreneur({this.status, this.approvedOn});

  Entrepreneur.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    approvedOn = json['approved_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['approved_on'] = approvedOn;
    return data;
  }
}

class User {
  String? id;
  String? updatedAt;
  String? username;
  String? name;
  String? firstName;
  String? lastName;
  String? twitterUsername;
  String? portfolioUrl;
  String? bio;
  String? location;
  Links1? links;
  ProfileImage? profileImage;
  String? instagramUsername;
  int? totalCollections;
  int? totalLikes;
  int? totalPhotos;
  bool? acceptedTos;
  bool? forHire;
  Social? social;

  User(
      {this.id,
      this.updatedAt,
      this.username,
      this.name,
      this.firstName,
      this.lastName,
      this.twitterUsername,
      this.portfolioUrl,
      this.bio,
      this.location,
      this.links,
      this.profileImage,
      this.instagramUsername,
      this.totalCollections,
      this.totalLikes,
      this.totalPhotos,
      this.acceptedTos,
      this.forHire,
      this.social});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    updatedAt = json['updated_at'];
    username = json['username'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    twitterUsername = json['twitter_username'];
    portfolioUrl = json['portfolio_url'];
    bio = json['bio'];
    location = json['location'];
    links = json['links'] != null ? Links1.fromJson(json['links']) : null;
    profileImage = json['profile_image'] != null
        ? ProfileImage.fromJson(json['profile_image'])
        : null;
    instagramUsername = json['instagram_username'];
    totalCollections = json['total_collections'];
    totalLikes = json['total_likes'];
    totalPhotos = json['total_photos'];
    acceptedTos = json['accepted_tos'];
    forHire = json['for_hire'];
    social = json['social'] != null ? Social.fromJson(json['social']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['updated_at'] = updatedAt;
    data['username'] = username;
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['twitter_username'] = twitterUsername;
    data['portfolio_url'] = portfolioUrl;
    data['bio'] = bio;
    data['location'] = location;
    if (links != null) {
      data['links'] = links!.toJson();
    }
    if (profileImage != null) {
      data['profile_image'] = profileImage!.toJson();
    }
    data['instagram_username'] = instagramUsername;
    data['total_collections'] = totalCollections;
    data['total_likes'] = totalLikes;
    data['total_photos'] = totalPhotos;
    data['accepted_tos'] = acceptedTos;
    data['for_hire'] = forHire;
    if (social != null) {
      data['social'] = social!.toJson();
    }
    return data;
  }
}

class PreviewPhotos {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? blurHash;
  Urls? urls;

  PreviewPhotos(
      {this.id, this.createdAt, this.updatedAt, this.blurHash, this.urls});

  PreviewPhotos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    blurHash = json['blur_hash'];
    urls = json['urls'] != null ? Urls.fromJson(json['urls']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['blur_hash'] = blurHash;
    if (urls != null) {
      data['urls'] = urls!.toJson();
    }
    return data;
  }
}

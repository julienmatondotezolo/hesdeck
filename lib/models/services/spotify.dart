class MainObject {
  Device device;
  String repeatState;
  bool shuffleState;
  Context context;
  int timestamp;
  int progressMs;
  bool isPlaying;
  Item item;
  String currentlyPlayingType;
  Actions actions;

  MainObject({
    required this.device,
    required this.repeatState,
    required this.shuffleState,
    required this.context,
    required this.timestamp,
    required this.progressMs,
    required this.isPlaying,
    required this.item,
    required this.currentlyPlayingType,
    required this.actions,
  });
}

class Device {
  String id;
  bool isActive;
  bool isPrivateSession;
  bool isRestricted;
  String name;
  String type;
  int volumePercent;
  bool supportsVolume;

  Device({
    required this.id,
    required this.isActive,
    required this.isPrivateSession,
    required this.isRestricted,
    required this.name,
    required this.type,
    required this.volumePercent,
    required this.supportsVolume,
  });
}

class Context {
  String type;
  String href;
  ExternalUrls externalUrls;
  String uri;

  Context({
    required this.type,
    required this.href,
    required this.externalUrls,
    required this.uri,
  });
}

class ExternalUrls {
  String spotify;

  ExternalUrls({required this.spotify});
}

class Item {
  Album album;
  List<Artist> artists;
  List<String> availableMarkets;
  int discNumber;
  int durationMs;
  bool explicit;
  ExternalIds externalIds;
  ExternalUrls externalUrls;
  String href;
  String id;
  bool isPlayable;
  Restrictions restrictions;
  String name;
  int popularity;
  String previewUrl;
  int trackNumber;
  String type;
  String uri;
  bool isLocal;

  Item({
    required this.album,
    required this.artists,
    required this.availableMarkets,
    required this.discNumber,
    required this.durationMs,
    required this.explicit,
    required this.externalIds,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.isPlayable,
    required this.restrictions,
    required this.name,
    required this.popularity,
    required this.previewUrl,
    required this.trackNumber,
    required this.type,
    required this.uri,
    required this.isLocal,
  });
}

class Album {
  String albumType;
  int totalTracks;
  List<String> availableMarkets;
  ExternalUrls externalUrls;
  String href;
  String id;
  List<Image> images;
  String name;
  String releaseDate;
  String releaseDatePrecision;
  Restrictions restrictions;
  String type;
  String uri;
  List<Artist> artists;

  Album({
    required this.albumType,
    required this.totalTracks,
    required this.availableMarkets,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.releaseDate,
    required this.releaseDatePrecision,
    required this.restrictions,
    required this.type,
    required this.uri,
    required this.artists,
  });
}

class Artist {
  ExternalUrls externalUrls;
  Followers followers;
  List<String> genres;
  String href;
  String id;
  List<Image> images;
  String name;
  int popularity;
  String type;
  String uri;

  Artist({
    required this.externalUrls,
    required this.followers,
    required this.genres,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.popularity,
    required this.type,
    required this.uri,
  });
}

class Followers {
  String href;
  int total;

  Followers({required this.href, required this.total});
}

class Image {
  String url;
  int height;
  int width;

  Image({required this.url, required this.height, required this.width});
}

class Restrictions {
  late String reason;
}

class Actions {
  bool interruptingPlayback;
  bool pausing;
  bool resuming;
  bool seeking;
  bool skippingNext;
  bool skippingPrev;
  bool togglingRepeatContext;
  bool togglingShuffle;
  bool togglingRepeatTrack;
  bool transferringPlayback;

  Actions({
    required this.interruptingPlayback,
    required this.pausing,
    required this.resuming,
    required this.seeking,
    required this.skippingNext,
    required this.skippingPrev,
    required this.togglingRepeatContext,
    required this.togglingShuffle,
    required this.togglingRepeatTrack,
    required this.transferringPlayback,
  });
}

class ExternalIds {
  String isrc;
  String ean;
  String upc;

  ExternalIds({required this.isrc, required this.ean, required this.upc});
}

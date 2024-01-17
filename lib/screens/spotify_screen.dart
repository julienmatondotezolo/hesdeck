import 'package:flutter/material.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifyScreen extends StatelessWidget {
  const SpotifyScreen({super.key});

  final String clientId = "821782afcd0341d2b7a75d0d808240e5";
  final String redirectURI = "com.hessdeck.tv.hessdeck://login-callback";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Spotify Control'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _connectToSpotify(clientId, redirectURI),
                child: const Text('Connect to Spotify'),
              ),
              ElevatedButton(
                onPressed: () => _playerState(),
                child: const Text('Player state'),
              ),
              ElevatedButton(
                onPressed: () => _pauseSong(),
                child: const Text('Pause Song'),
              ),
              ElevatedButton(
                onPressed: () => _resumeSong(),
                child: const Text('Resume Song'),
              ),
              ElevatedButton(
                onPressed: () => _nextSong(),
                child: const Text('Next Song'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _connectToSpotify(String clientId, String redirectURI) async {
    await SpotifySdk.connectToSpotifyRemote(
      clientId: clientId,
      redirectUrl: redirectURI,
    );

    final accessToken = await SpotifySdk.getAccessToken(
        clientId: clientId,
        redirectUrl: redirectURI,
        scope: "streaming,user-modify-playback-state,playlist-read-privat"
        // scope:
        //     "app-remote-control,user-modify-playback-state,playlist-read-private",
        );

    SpotifySdk.subscribePlayerState();
    SpotifySdk.subscribePlayerContext();

    debugPrint('access token: $accessToken');
    print('access token: $accessToken');
  }

  void _playerState() async {
    final playerState = await SpotifySdk.getPlayerState();

    debugPrint('player state: $playerState');
    print('player state: $playerState');
  }

  void _pauseSong() async {
    final pause = await SpotifySdk.pause();

    debugPrint('pause: $pause');
    print('pause: $pause');
  }

  void _resumeSong() async {
    final resume = await SpotifySdk.resume();

    debugPrint('resume: $resume');
    print('resume: $resume');
  }

  void _nextSong() async {
    final next = await SpotifySdk.skipNext();

    debugPrint('next: $next');
    print('next: $next');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_api/spotify_api.dart';

class SpotifyScreen extends StatelessWidget {
  const SpotifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? clientId = dotenv.env['CLIENT_ID'];
    String? clientSecret = dotenv.env['CLIENT_SECRET'];
    String? redirectUri = dotenv.env['REDIRECT_URL'];

    print({
      clientId: clientId,
      clientSecret: clientSecret,
      redirectUri: redirectUri,
    });

    // SpotifyApi spotifyAuth = SpotifyApi();
    SpotifyApi spotifyAuth = SpotifyApi(
      clientId: '821782afcd0341d2b7a75d0d808240e5',
      clientSecret: '6bfb65fa73cf4f2bb7e6cea4841e6bc9',
      redirectUri: 'com.hessdeck.tv.hessdeck://login-callback',
    );

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await spotifyAuth.launchAuth(context);

                  // List<dynamic> playlists = await spotifyAuth.getUserPlaylists();
                  // print(playlists);
                },
                child: const Text('Authenticate with Spotify'),
              ),
            ),
            const Spacer(),
            const Text(
              'Data',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await spotifyAuth.startPlayback();
              },
              child: const Text('Start playback'),
            ),
            ElevatedButton(
              onPressed: () async {
                await spotifyAuth.pausePlayback();
              },
              child: const Text('Pause playback'),
            ),
            ElevatedButton(
              onPressed: () async {
                await spotifyAuth.nextPlayback();
              },
              child: const Text('Next playback'),
            ),
            ElevatedButton(
              onPressed: () async {
                await spotifyAuth.previousPlayback();
              },
              child: const Text('Previous playback'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await spotifyAuth.disconnect();
              },
              child: const Text('Disconnect'),
            )
          ],
        ),
      ),
    );
  }
}

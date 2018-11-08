MOSBot
======

A bot playing [Marbles On Stream](http://pixelbypixelcanada.com/mos.html) with Twitch streamers. Written in Ruby.

How does it work?
-----------------

MOSBot
- fetches every 2 minutes up to 25 Twitch live streams featuring Marbles On Stream with more than 50 viewers
- joins these channels and waits for many people to enter "!play" in the chat
- joins the game by sending a "!play" message to the Twitch Chat
- waits 210 seconds before play detection starts again

Features
--------

- doesn't spam chat
- only sends a !play message if there are other players
- automatically joins new streams
- automatically leaves streams not playing MOS any longer

Configuration
-------------

MOSBot needs an OAuth key to join the Twitch Chat and a client ID to
fetch streams from the Twitch Kraken API. You can edit the configuration
in config.yml.

How to get an Twitch Chat OAuth key? Use the [Twitch Chat OAuth Password Generator](https://twitchapps.com/tmi/).

How to get a client ID? [Register the app on the Twitch dev portal](https://dev.twitch.tv/dashboard/apps/create).

Dependencies
------------

 - [Cinch](https://github.com/cinchrb/cinch) - IRC bot library used for joining Twitch Chat
 - [HTTParty](https://github.com/jnunemaker/httparty) - http library used for Twitch API requests

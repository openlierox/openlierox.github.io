---
layout: default
title: News
permalink: /news/
rss: true
---
<div class="news_item">

# [Release] OpenLieroX 0.59 beta10
{:.news_title}

2012-04-17 by **albert**
{:.news_posted}

About the OLX 0.59 beta 10 release:

"1,306 changed files with 159,276 additions and 173,652 deletions"

Downloads:

- [Windows](http://sourceforge.net/projects/openlierox/files/openlierox/OpenLieroX%200.59%20beta10/OpenLieroX_0.59_beta10.win32.zip/download)
- [MacOSX](http://sourceforge.net/projects/openlierox/files/openlierox/OpenLieroX%200.59%20beta10/OpenLieroX_0.59_beta10.mac.dmg/download)
- [source code](http://sourceforge.net/projects/openlierox/files/openlierox/OpenLieroX%200.59%20beta10/OpenLieroX_0.59_beta10.src.tar.bz2/download) (sorry, no Ubuntu/Debian package for now... but as usual, building on Linux is easy)

It has been a long time. This was mostly that we have been inactive on OLX for quite some time. However, in the last 3 months, I got quite active again and made quite a lot of huge internal changes. These changes are some of the biggest internal changes since the first OLX release. Not all changes are directly visible to you, though.

**game object serialization system**

This is mostly internal. But this is the biggest change. It means that all game objects are serializable. This basically means that you can access every object and every attribute from everywhere (i.e. right now from Lua scripts or from console).

This is also used now to sync the state over network. Most of the old network code has become obsolete now and isn't used anymore if you have only >=0.59b10 versions in a network game. Right now, the network sync implementation is quite simple but this whole design greatly allows for huge improvements in the future. The network engine was not really tested that well yet, esp not over laggy networks. If it turns out that the performance is too bad for playing, this can easily be improved later based on this work.

The possibilities for Lua are also huge. You can basically control the whole game. There is also a new global Lua instance which is always available, even when you are not running a game. You could script the game in any way you want it. (In the future, you might script your own clan ladder system based on that. Or LXA account integration. Or some extended GUI. Or your people banning system. Some server filtering. ...) And of course do also some more crazy stuff in maps/mods (whatever you can imagine -- you really have access to *everything*).

**Gusanos stabilization**

There has been quite some work on the Gusanos code to make it more stable. It should basically just work now. Also the Gusanos network engine got cleaned up a bit. In earlier 0.59 releases, Gusanos over network was not really playable at all. My hope is that this has changed now.

**merge Gusanos/LX drawing**

This has huge implications. Basically all Gusanos special effects such as lightning, shadows, distortion can be used in LX. Gusanos is drawn at high-res now. I.e. worms don't look pixelized anymore. Also the special effects are high-res.

Want to play around? Type `lua game.levelDarkMode = true` in console. Or test some of the countless Gusanos maps/mods.

For OLX, I also simplified the HUD. It is overlayed now and the game gets the full screen. I think this is a somewhat nicer gameplay.

---

Some more changes. Not complete (see below for more).

- weapon slots became dynamic. custom sizes possible. new option WeaponSlotsNum
- Teeworlds (https://www.teeworlds.com/) level support (mostly complete)
- new pixel flags types: no hook, damage area
- foreground level graphic support (put foreground.png in your (Gus) level dir)
- Gusanos high-res level support (double_res = 1 in config.cfg)
- draw arrow in race mode to the next check point
- console persistence history support
- level dark mode used in Hide&Seek
- Lua startup scripts (startup*.lua)
- console: `lua` - executes Lua code in the global Lua instance
- press jump to spawn worm support
- HUD feedback: "Waiting for respawn ..." and others
- MaxRespawnTime option. If enabled (>=0) and if both this time and RespawnTime went by, the worm is automatically spawned
- termios console CLI support based on linenoise (for Unix/Linux/MacOSX)
- simplification of internal game state and game loop
- fixes in net channel bandwidth handling
- unified server/client code. shares same gamestate (map, mod, etc)
- many Gusanos cleanups and fixes
- single player game config structure simplified

For all more complete list of changes, see [here](http://www.openlierox.net/forum/index.php/topic,13676) or read doc/ChangeLog from the release. For even more details, [this](https://github.com/albertz/openlierox/compare/0.59_beta9...0.59_beta10) is the full Git change log.

---

Some drawbacks:

A lot of code has been rewritten and is completely new. This means that it might be buggy and it is also not that well optimized yet. In particular, this is for the graphics code, the main engine and the network engine. E.g., the graphics code is slower than earlier and you will notice this in lower FPS. Also, map/projectile shadows aren't implemented yet. And some other stuff might be missing too (please report). The network code is also not optimized yet.

The MacOSX release currently only supports MacOSX >=10.6 with 64bit Intel. It's quite annoying/complicated to have wider support. The OLX code itself should support just anything (ppc, ppc64, i386, x86_64, from MacOSX 10.1 on), however, it's somewhat complicated to get the libraries for each target arch. Anyway, I'm curious how important this is. If there are too much requests for earlier MacOSX versions or other archs, I'll probably add that support back. For now, if you happen to have such old MacOSX version, you might consider compiling OLX yourself which is not too complicated on OSX.

<div class="news_comments">
[22 comments](http://lxalliance.net/forum/index.php/topic,13681.0.html)
</div>
</div>

<div class="news_item">

# source code and tracker moved to GitHub
{:.news_title}

2011-05-14 by **albert**
{:.news_posted}

Hi,

The main repository has been moved to GitHub:

<https://github.com/albertz/openlierox>

All the old bug reports and feature requests also have been moved to GitHub:

<https://github.com/albertz/openlierox/issues>

The SourceForge trackers were disabled. The Git repository will also be disabled in a while to not confuse other people where to find the most recent source.

The openlierox-distrib repository (with all the distribution scripts) has been moved here:

<https://github.com/albertz/openlierox-distrib>

---

What this means:

For users, it will make the bug reporting a bit different. Most people will probably agree that the GitHub issue tracker is much nicer to use. Though, right now, it means that you need a GitHub account. But we are working on possible solutions so that you can also report without a GitHub account. Otherwise, no real (direct) change for you.

For developers, it means to just change the Git origin URL in your local Git copy. And you can take advantage of all the nice GitHub Git features. And it will make a few other things easier in the future.

For other people interested in the source, it has the biggest impact: The project is on GitHub now! (People who like working on Open Source projects probably are familiar with what this means already.) Basically, it means that contributing to the source code is trivial now. It's just one click away.

Some further discussion about this can be read in the mailing list. After all, if you don't care about contributing to the source code, it doesn't really mean too much for you right now.

<div class="news_comments">
[3 comments](http://lxalliance.net/forum/index.php/topic,13342.0.html)
</div>
</div>

<div class="news_item">

# LXA as an OpenID provider
{:.news_title}

2010-07-14 by **albert**
{:.news_posted}

OpenID is a way to login on many websites. You probably have seen it already somewhere.

OpenID itself is just the system. Famous examples of OpenID providers are Google, Yahoo and many more. And now also LXA. This means, on any other website with supports OpenID logins, you can use your LXA account now.

I tried to demonstrate this here for SourceForge ([video](http://www.youtube.com/watch?v=FH-SOmvI588)).

Sorry, the video is a bit fast. What it shows is basically:

- I logged out of LXA (and am already logged out of SF).
- I go to the SF login page, select custom OpenID login, and enter the OpenID URL.
- That brings me to the LXA login.
- After entering that one (well, just press enter as it remembered my values), it returns to SF and says I am logged in to SF now.
- I go back to LXA. SF didn't just checked the LXA password, it actually has used the LXA login, i.e. I'm also logged in to LXA now.
- I log out on SF.
- Show that I am still logged in to LXA.
- I use the same OpenID login on SF again.
- This time, I don't have to enter the LXA user/pass again because I'm still logged in on LXA. This shows that SF actually only checks if you are logged in on LXA. SF doesn't really see your password at any time (all that is handled on the LXA side).

As I haven't seen any SMF plugin which provides that functionality, I have coded it myself: <http://github.com/albertz/smf-openid-server>

The code is a bit experimental. Please report problems/bugs. Will post that also later in the SMF community, maybe it is useful.

This was a first step to have user logins in OpenLieroX. By choosing OpenID, it will be possible to use any OpenID login in OLX, i.e. you can use your LXA account, your Google account or whatever.

<div class="news_comments">
[15 comments](http://lxalliance.net/forum/index.php/topic,13104.0.html)
</div>
</div>

<div class="news_item">

# Why game development is a great learning playground
{:.news_title}

2010-05-16 by **albert**
{:.news_posted}

Why game development is a great learning playground. All the topics you can learn about when developing a game.

<http://www.openlierox.net/wiki/index.php/Why_game_development_is_a_great_learning_playground>

<div class="news_comments">
[2 comments](http://lxalliance.net/forum/index.php/topic,13042.0.html)
</div>
</div>

<div class="news_item">

# Contribute to OpenLieroX
{:.news_title}

2010-05-09 by **albert**
{:.news_posted}

OpenLieroX can use your help in many ways. If you are interested in contributing to OpenLieroX in some way, I have summarized the possibilities in a Wiki article here:

<http://www.openlierox.net/wiki/index.php/Contribute>

I have also written an article in case you want to learn coding. In that case, OpenLieroX is a good project to start with. But also otherwise, contributions on the source code are highly welcome. Read the full article here:

<http://www.openlierox.net/wiki/index.php/Contribute_to_the_source_code>

<div class="news_comments">
[12 comments](http://lxalliance.net/forum/index.php/topic,13015.0.html)
</div>
</div>

<div class="news_item">

# Dedicated server ranking
{:.news_title}

2010-04-09 by **albert**
{:.news_posted}

Hey,

As you may know, there are some dedicated servers running on our LXA host. Most of them also include some sort of ranking system. Usually, you can see the rank on the server by writing "!rank", "!rankall" or "!toprank" in the chat on such server.

For the Fast Mortars server (and others can easily be added), I have written a small script now which automatically pushes the rank list online and updates it every 5 minutes.

New: We also have simple clan ranking now! <http://www.openlierox.net/pwn0meter_olx_mortsfast.html>

New: Also for Rifles server: <http://www.openlierox.net/pwn0meter_olx_rifles.html>

PS: I still would be happy to see more/other dedicated servers online. If you don't have the hardware to do that, contact DarkCharlie and you probably can get an own access on the LXA host. You can also post/suggest some own configs/scripts if you want and I may use them.

PS2: For some reason, the rank list is slightly different from the rank you see when you type "!rank" on the server. I didn't wrote those scripts and I'm too lazy right now to find out why that is :) but feel free to look yourself at the Python code and post a patch.

<div class="news_comments">
[25 comments](http://lxalliance.net/forum/index.php/topic,12956.0.html)
</div>
</div>

<div class="news_item">

# [Release] OpenLieroX 0.59 beta
{:.news_title}

2010-01-21 by **albert**
{:.news_posted}

Hey again,

There it is: The first 0.59 beta release. Please note that this time, "Beta" really means Beta. There are many crashes and there are huge memleaks. And who knows what other problems. But it's finally at a stage where I would say it is playable and you can try out all the fancy new things.

Well, the main new feature - you may have heard already about it - we have full Gusanos support now!

For those who don't know, Gusanos is another Liero clone, as old as LieroX (actually, I don't know - who was first, can somebody tell?), with much nicer physics, sound and gfx effects (well, physics may be subjective). The reason why (O)LX has become the favourit is because Gusanos was not really so intuitive to use (most of the life of this game, it didn't had a GUI) and it was restricted mostly to Windows only (Linux x86 was theoretically supported but it had dependencies to some comercial libs which were mostly not available on distributions). Checkout some videos on Youtube (or linked here on LXA) to get some impression about Gusanos. There are also a lot of really fancy mods and levels for Gusanos. Gusanos mods and levels are highly scripted. It is all based on Lua and you can do a lot of stuff - and I mean really a lot. There are levels with rain, jumppads, damaging elements and many dynamic elements here and there. There are also dynamic lights and you got a flashlight to see something.

All that is in OLX now. OLX is compatible to most Gusanos levels/mods out-of-the-box! (And those who don't work should be trivial to be fixed.)

This support goes very far: You can easily play some LX mod in a scripted Gusanos map. Check out the Gusanos Poo map. There is a jumppad on the bottom. :) That works also the other way around: You can play any LX map with Gusanos mods.

Despite this mixing, all OLX gamemodes (like CTF, race, Hide&Seek, etc) should also work with Gusanos. Esp. try out CTF and some of the Gusanos CTF maps. You will notice that there are fixed spawnpoints for each team and also the flag base is at a fixed place (those maps were esp. made for CTF). And most other OLX settings are also handled.

Warning: Set your loading time to 100 when you play some Gusanos mod. Some Gusanos mods may take up a lot of CPU and with too low loading time, they will easily make it unplayable.

Documentation about how to create your own Gusanos mods and maps are online, together with some more details about the merging and the Gusanos state in OpenLieroX: <http://www.openlierox.net/wiki/index.php/Gusanos>

Ok, so far to the Gusanos support.

Then, there are 3D sounds now. That was introduced mainly because of Gusanos (which always had 3D sounds). The overall quality of the sounds should also be improved. We use OpenAL now.

And we have some more sounds for some ingame announcements, like "3 frags left", timeouts and some more stuff, also for CTF. Just see yourself. Those sounds were taken from the very nice [Open Source 3D shooter Nexuiz](http://www.alientrap.org/nexuiz/).

And we have single player support now. :) This is mainly thought to provide some nice introduction / tutorial for newcomers. But maybe some of you is interested in creating a whole game? In any way, I hope I can get some further tutorial levels from you. More information will come later but it's mostly straight forward to be used (checkout the games directory).

I think that was all important stuff. Try it out. :)

Download here: <http://www.openlierox.net/downloads/>

<div class="news_comments">
[276 comments](http://lxalliance.net/forum/index.php/topic,12826.0.html)
</div>
</div>

<div class="news_item">

# [Release] OpenLieroX 0.58 rc
{:.news_title}

2010-01-21 by **albert**
{:.news_posted}

Heya,

I am proud to announce the first stable release of the 0.58 version.

For some more details about what has changed between 0.57 and 0.58, and also some details about the development process of 0.58 itself, take a look [here](http://www.openlierox.net/forum/index.php/topic,12642.msg198750.html#msg198750).

Here a rough overview about the changes of the latest beta (0.58 beta9) and the 0.58 rc2:

- many crashes fixed
- somewhat better performance
- tooltip in chat for userinfo disappears correctly
- possibility to disable weapon combos
- some new default settings (only for those who start OLX for the first time)

Download here: <http://www.openlierox.net/downloads/>

<div class="news_comments">
[62 comments](http://lxalliance.net/forum/index.php/topic,12825.0.html)
</div>
</div>

<div class="news_item">

# Some news in development organisation
{:.news_title}

2009-10-05 by **albert**
{:.news_posted}

As it has been planned for a long time, the development management has changed. This change solves the problem with a complicated work on multiple versions at the same time. Also release creation has been simplified a lot, which will lead to more frequent releases.

The project has migrated from SVN to Git. There are 3 main branches (versions) at the moment: 0.57, 0.58 and the master. The master is always the most up-to-date code, it's the code for the upcoming 0.59 version.

For an impression follow the link and look at the bottom of the page under heads: <https://github.com/albertz/openlierox>

New releases will be created far more often. Nightly builds have been abandoned and will not be released anymore. A new beta release will be created if there's something to test.

A beta release is, as the name says, a testing release. There are known issues and the version is not always stable.

For bigger changes, a whole new version will be created (e.g., last is 0.58 now, next will be 0.59). For versions which look more promising or which are very much liked by the community, there will probably be more beta releases.

If there is one version, where the last beta release has became stable enough, a release candidate (RC) version will be released. If the RC version is stable, it will be marked as a final stable version.

<div class="news_comments">
[8 comments](http://lxalliance.net/forum/index.php/topic,12643.0.html)
</div>
</div>

<div class="news_item">

# [Release] OpenLieroX 0.58 beta
{:.news_title}

2009-10-05 by **albert**
{:.news_posted}

This is an interesting new release.

For the first time in OpenLieroX history, the version number was increased. This version is not 0.57 anymore, but 0.58.

This release contains basically everything new that was done since 0.57 beta8. And this is a lot.

A very short summary:

- uploadlimit check fixed + automatic measuring of speed
- more stable network (CChannel3)
- improved HTML viewer
- IRC support
- dedicated server becomes useable
- improved connect-during-game
- background music by Corentin Larsen
- damage reporting (shows how much you injured a worm)
- new game options dialog
- ingame console can be used everywhere, also in menu
- ingame console much more advanced, many new commands, better autocompletion
- new debug logging system
- Hide & Seek gamemode
- Capture The Flag gamemode
- Race / Team Race gamemodes
- air jumping as an optional feature
- extended physics engine / gamescript (still in development)
- high-resolution level support
- possibility to make maps infinite
- possibility to disable minimap
- support for Commander Keen 1-3 levels
- game size factor (you can make everything bigger or smaller)
- hit/damage yourself/teammembers can be enabled/disabled (aka friendly fire on/off)
- immediate start
- worm speed/damage/shield/friction factor
- projectile friction factor
- physics should be exactly like LX56 now
- select weapons ingame (chat command /weapons)

Noteable new things over the 0.58 subreleases:

- new crashhandler, based on breakpad
- some fixes here, some improvements there

----

All files (currently Windows, Windows patch, MacOSX, Debian/Ubuntu i386, Debian/Ubuntu amd64 and source code) can be downloaded here: <http://www.openlierox.net/downloads/>

Remember, this is a beta release. Most things will work in this version and there are a lot of new and nice things to discover, but there are also some known issues.

Some of the issues are described here: <https://sourceforge.net/tracker/?group_id=180059&atid=891648>

**If you see any problems, please report them!**

Enjoy!

<div class="news_comments">
[305 comments](http://lxalliance.net/forum/index.php/topic,12642.0.html)
</div>
</div>

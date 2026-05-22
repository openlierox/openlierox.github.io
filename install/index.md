---
layout: default
title: Installation
permalink: /install/
---
## Installation under Windows

Unpack the game wherever you like and run OpenLieroX.exe. If the firewall asks
you if it should allow network communication for OpenLieroX, answer yes.

## Installation under Ubuntu

[Download the .deb package for your platform]({{ '/downloads/' | relative_url }}).
Double-click the downloaded file and click on Install package. The game will be
installed and you can access it from Applications &ndash; Games menu.

## Installation under Gentoo

[Download the provided ebuild]({{ '/downloads/' | relative_url }}) and install
it. For example, you can do this using (bad but simple way):

```
su -
cd /usr/portage
mkdir -p games-action/openlierox
cd games-action/openlierox
wget
echo "games-action/openlierox ~x86" >> /etc/portage/package.keywords
FEATURES="-strict" emerge openlierox
```

You can also use the [Roslin overlay](http://my.opera.com/lazy_bum/blog/2007/10/08/mammy-daddy-i-want-roslin),
they have included OpenLieroX Beta5.

Please post any success-stories on Gentoo at this topic on the
[Gentoo-Bugtracker](http://bugs.gentoo.org/show_bug.cgi?id=164009).

## General installation from source (Linux/Unix/BSD/Mac OS X)

Either download the most recent source archive from the
[download section]({{ '/downloads/' | relative_url }}) and extract it or get
the sources from SVN by the following command:

```
svn co https://openlierox.svn.sourceforge.net/svnroot/openlierox openlierox
```

Take a look into the file DEPS for the information, which dependencies are
needed. Install the missing dependencies.

Then use the compile.sh to compile it. If you want to install it into your
system, use the install.sh. Take a look at these both scripts, if you want
information about environment-variables you can use.

Use the start.sh script, if you don't want to install it. For example:

```
./compile.sh
./start.sh
```

## Manual installation under Debian/Ubuntu

Follow the general installation from source instructions. There's one
difference though: HawkNL doesn't exist for Debian/Ubuntu. But there is a
possibility to compile OpenLieroX with HawkNL builtin. Simply do (after you
have installed the needed dependencies):

```
HAWKNL_BUILTIN=1 ./compile.sh
```

If you are getting some errors (missing applications, libraries, or other
files), you might try this ultimate one-line command (paste it to Terminal)
that will download everything that is needed and compile OpenLieroX:

```
sudo apt-get install build-essential subversion cmake libsdl1.2-dev libsdl-mixer1.2-dev libsdl-image1.2-dev libgd2-noxpm-dev zlib1g-dev libzip-dev libxml2-dev libx11-dev ; svn co https://openlierox.svn.sourceforge.net/svnroot/openlierox ; cd openlierox ; cmake -D HAWKNL_BUILTIN=1 -D DEBUG=0 -D X11=1 ./ ; make
```

You can then run OpenLieroX anytime by opening the Terminal and typing:

```
cd openlierox
./start.sh
```

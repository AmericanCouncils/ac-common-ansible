#!/bin/sh

# custom install script for ffmpeg for use on travis

# TODO: Use /usr/local/bin as bindir, don't install to $HOME/bin and move after

# fail entire script on first error
set -e

rm -rf ~/ffmpeg_sources
rm -rf ~/ffmpeg_build

## dependencies
sudo apt-get -y install autoconf automake build-essential git libass-dev libgpac-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev \
  libxext-dev libxfixes-dev pkg-config texi2html zlib1g-dev
mkdir -p ~/ffmpeg_sources

## yasm
cd ~/ffmpeg_sources
wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
tar xzvf yasm-1.2.0.tar.gz
cd yasm-1.2.0
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install
make distclean
. ~/.profile

## x264
cd ~/ffmpeg_sources
git clone git://git.videolan.org/x264.git
cd x264
git checkout dfdb6465dea2990a4531d076ed2644c8ccb0f3a9
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make
make install
make distclean

## fdk-aac
cd ~/ffmpeg_sources
git clone git://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
git checkout 2f29dd48d02d402169246e3c7f9256869817392a
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean

## libmp3lame
sudo apt-get install nasm
cd ~/ffmpeg_sources
wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="$HOME/ffmpeg_build" --enable-nasm --disable-shared
make
make install
make distclean

## libopus
cd ~/ffmpeg_sources
wget http://downloads.xiph.org/releases/opus/opus-1.0.3.tar.gz
tar xzvf opus-1.0.3.tar.gz
cd opus-1.0.3
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean

## libvpx
cd ~/ffmpeg_sources
git clone http://git.chromium.org/webm/libvpx.git
cd libvpx
git checkout d6606d1ea734bbd7b3ab3e0852cedace5e4f0cd6
./configure --prefix="$HOME/ffmpeg_build" --disable-examples
make
make install
make clean

## FFMPEG!!
cd ~/ffmpeg_sources
git clone git://source.ffmpeg.org/ffmpeg
cd ffmpeg
git checkout 259292f9d484f31812a6ecbf4bfd3efd7c5905fd
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig"
export PKG_CONFIG_PATH
./configure --prefix="$HOME/ffmpeg_build" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --bindir="$HOME/bin" --extra-libs="-ldl" --enable-gpl --enable-libass --enable-libfdk-aac \
  --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx \
  --enable-libx264 --enable-nonfree --enable-x11grab
make
make install
make distclean
hash -r

sudo mv $HOME/bin/ffmpeg /usr/local/bin/ffmpeg

# TODO: Delete ffmpeg_sources and ffmpeg_build after we're done

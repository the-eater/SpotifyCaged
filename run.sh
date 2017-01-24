#!/usr/bin/env bash
DIR="$(realpath $(dirname $0))"

docker build -t spotify-caged .
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -
docker run -ti --device=/dev/snd -v "/run/user/$(id -u)/pulse/native":"/pulse-sock" -v "$XSOCK":"$XSOCK" -v "$XAUTH":"$XAUTH" -v "$DIR/cache":"/home/spotify/.cache/spotify" -e XAUTHORITY="$XAUTH" spotify-caged

#!/usr/bin/env bash

docker build -f ./arch/pbrt_DOCKERFILE . -t pbrt4-appimage

CONTAINER_ID=$(docker create pbrt4-appimage)
docker cp $CONTAINER_ID:/pbrt .
docker rm $CONTAINER_ID
mv pbrt4 "$HOME/.local/bin"

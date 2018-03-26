#!/usr/bin/env sh

image=${REPO:-local}/${IMAGE:-rclone-mount}:${TAG:-debian_stretch-slim}
echo "Running image ${image}"

docker run --rm --name  debian_stretch-slim -it  ${image} /bin/sh

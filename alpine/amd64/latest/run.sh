#!/usr/bin/env sh

image=${REPO:-local}/${IMAGE:-rclone-mount}:${TAG:-alpine_latest}
echo "Running image ${image}"

docker run --rm --name  alpine_latest -it  ${image} /bin/sh

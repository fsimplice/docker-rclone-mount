#!/usr/bin/env sh

image=${REPO:-local}/${IMAGE:-rclone-mount}:${TAG:-debian_stretch}
echo "Running image ${image}"

docker run --rm --name  debian_stretch -it  ${image} /bin/sh

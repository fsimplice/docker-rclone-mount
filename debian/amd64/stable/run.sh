#!/usr/bin/env sh

image=${REPO:-local}/${IMAGE:-rclone-mount}:${TAG:-debian_stable}
echo "Running image ${image}"

docker run --rm --name  debian_stable -it  ${image} /bin/sh

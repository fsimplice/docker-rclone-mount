#!/usr/bin/env sh

image=${REPO:-local}/${IMAGE:-rclone-mount}:${TAG:-debian_stable-slim}
echo "Running image ${image}"

docker run --rm --name  debian_stable-slim -it  ${image} /bin/sh

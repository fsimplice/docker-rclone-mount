#!/usr/bin/env sh

image=${REPO:-local}/${IMAGE:-rclone-mount}:${TAG:-__IMAGE_TAG__}
echo "Running image ${image}"

docker run --rm --name  __IMAGE_TAG__ -it  ${image} /bin/sh

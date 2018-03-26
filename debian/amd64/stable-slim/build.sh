#!/usr/bin/env sh

image=${REPO:-local}/${IMAGE:-rclone-mount}:${TAG:-debian_stable-slim}

echo "Using BUILD_OPTS=${BUILD_OPTS}"
echo "Building ${image}"

docker build ${BUILD_OPTS} . -t ${image}
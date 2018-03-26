#!/usr/bin/env sh

image=${REPO:-local}/${IMAGE:-rclone-mount}:${TAG:-debian_stable-slim}
echo "Testing image ${image}"

OPTS="-test.v -test.timeout 60s"
${CONTAINER_TEST_BIN_PATH:-../../..}/container-structure-test ${OPTS}  -image ${image} ${CONTAINER_TEST_FILE_PATH:-../../..}/structure-test/tests-${ARCH:-amd64}.yaml

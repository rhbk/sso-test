#!/bin/bash

set -e

ARCH="amd64 s390x ppc64le arm64"
VERSION="${1:-latest}"
REGISTRY="${2:-quay.io}"
NAMESPACE="${3:-keycloakqe}"

IMAGE_NAME="${REGISTRY}/${NAMESPACE}/interop-ocp-ci:${VERSION}"

echo "Creating a new manifest: ${IMAGE_NAME}"
podman manifest create ${IMAGE_NAME}

echo "Building a new docker image: ${IMAGE_NAME}, arch: ${ARCH}"
for i in $ARCH
do
  podman build --arch=$i -t ${IMAGE_NAME}.${i} --build-arg ARCH=${i} --build-arg VERSION=${VERSION} -f docker-container-executor/Dockerfile .
  podman push ${IMAGE_NAME}.${i}
  podman manifest add ${IMAGE_NAME} ${IMAGE_NAME}.${i}
done

echo "Pushing a new manifest: ${IMAGE_NAME}"
podman manifest push ${IMAGE_NAME} docker://${IMAGE_NAME}


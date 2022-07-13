#!/bin/bash

build_image() {
  echo "Building '${IMAGE_TAG}' tag."
  docker build \
    -t "${IMAGE_NAME}:${IMAGE_TAG}" \
    -f "${DOCKER_IMAGE_PATH}" "${DOCKER_BUILD_CONTEXT}"
}

push_image() {
  echo "Pushing '${IMAGE_TAG}' tag."
  docker push "${IMAGE_NAME}:${IMAGE_TAG}"
  echo "Pushed public image : ${IMAGE_NAME}"
}

build_image
[ $? -eq 0 ] || exit 1
push_image
[ $? -eq 0 ] || exit 2

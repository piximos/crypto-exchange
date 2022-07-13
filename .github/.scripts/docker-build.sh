#!/bin/bash

IMAGE="${REGISTRY_URI}/${DOCKER_PROJECT}/${IMAGE_NAME}"
GITHUB_COMMIT_HASH=${GITHUB_SHA:0:8}

  VERBOSE_BUILD="true"
if [[ -z ${GITHUB_PR_NUMBER} ]]; then
  VERBOSE_BUILD="false"
fi

build_image() {
  img_tag="${1}"
  echo "Building '${img_tag}' tag."
  docker build \
    --build-arg SA_BASE_VERSION="${img_tag}" \
    -t "${IMAGE}:${img_tag}" \
    -f "${DOCKER_IMAGE_PATH}" "${DOCKER_BUILD_CONTEXT}" \
    --build-arg VERBOSE_BUILD="${VERBOSE_BUILD}" \
    --build-arg ANGULAR_BUILD_HEAP_SIZE="${BUILD_HEAP_SIZE}" \
    --progress plain
}

push_image() {
  img_tag="${1}"
  echo "Pushing '${img_tag}' tag."
  docker push "${IMAGE}:${img_tag}"
  echo "Pushed public image : ${IMAGE_NAME}"
}

clean_up() {
  echo "Deleting '${img_tag}' from local."
  img_tag="${1}"
  docker rmi "${IMAGE}:${img_tag}" || true
}

if [[ -z ${GITHUB_PR_NUMBER} ]]; then
  IMAGE_TAG="${GITHUB_BRANCH#refs/heads/}-${GITHUB_COMMIT_HASH}"
else
  IMAGE_TAG="pr-${GITHUB_PR_NUMBER}-${GITHUB_PR_BASE_BRANCH}-${GITHUB_COMMIT_HASH}"
fi

build_image "${IMAGE_TAG}"
[ $? -eq 0 ] || exit 1
push_image "${IMAGE_TAG}"
[ $? -eq 0 ] || exit 2
clean_up "${IMAGE_TAG}"

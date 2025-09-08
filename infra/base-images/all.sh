#!/bin/bash -eux
# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

# The first argument is the version tag, e.g., 'latest', 'ubuntu-20-04'.
VERSION_TAG=${1:-latest}

# Define a function to build a specific image with the correct Dockerfile and tag.
build_image() {
  local image_name=$1
  local image_dir="infra/base-images/$2"
  local full_image_name="gcr.io/oss-fuzz-base/$image_name"
  
  if [ "$VERSION_TAG" == "latest" ]; then
    dockerfile="$image_dir/Dockerfile"
  else
    dockerfile="$image_dir/$VERSION_TAG.Dockerfile"
  fi

  if [ ! -f "$dockerfile" ]; then
    echo "Skipping $dockerfile since it does not exist."
    return
  fi

  # The '-t' flag tags the image.
  docker build --pull -t "$full_image_name:$VERSION_TAG" -f "$dockerfile" "$@" "$image_dir"
}

# Build all base images.
build_image "base-image" "base-image"
build_image "base-clang" "base-clang"
build_image "base-builder" "base-builder"
build_image "base-builder-go" "base-builder-go"
build_image "base-builder-jvm" "base-builder-jvm"
build_image "base-builder-python" "base-builder-python"
build_image "base-builder-rust" "base-builder-rust"
build_image "base-builder-ruby" "base-builder-ruby"
build_image "base-builder-swift" "base-builder-swift"
build_image "base-runner" "base-runner"
build_image "base-runner-debug" "base-runner-debug"

echo "Built all images successfully for version $VERSION_TAG"
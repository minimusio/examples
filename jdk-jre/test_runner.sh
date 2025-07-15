#!/bin/bash
set -e

PROJECT="jke-jre-tls-test"
TEST_COMPOSE="docker-compose.yml"
IMAGE_LIST="minimus_images.txt"
BACKUP_SUFFIX=".backup.$$"
CERTGEN_COMPOSE='create-certs.yml'
DOCKERFILE_ORIG="Dockerfile.app"

PASSED_IMAGES=()
FAILED_IMAGES=()

# Backup original files
cp "$DOCKERFILE_ORIG" "${DOCKERFILE_ORIG}${BACKUP_SUFFIX}"

generate_certs() {
  echo "[INFO] Running cert generation using $CERTGEN_COMPOSE..."
  docker compose -f "$CERTGEN_COMPOSE" up --abort-on-container-exit --build
  sleep 1
}

cleanup_all() {
  echo "[INFO] Cleaning up Docker Compose environment…"
  docker compose -f "$TEST_COMPOSE" down -v --remove-orphans || true
  docker container prune -f || true
  docker volume prune -f || true
  docker network prune -f || true
}

run_test_for_config() {
  local runtime_image="$1"
  local builder_image="$2"
  echo ""
  echo "[INFO] Testing with:"
  echo "  JRE runtime image: $runtime_image"
  echo "  JDK builder image: $builder_image"


  echo "[INFO] Applying replacements..."
  sed -i -E "s|^FROM .+ AS build|FROM $builder_image AS build|" "$DOCKERFILE_ORIG"

  sed -i -E "/^FROM /{/AS builder/!s|^FROM .+|FROM $runtime_image|}" "$DOCKERFILE_ORIG"

  # Build and test
  if docker compose -f "$TEST_COMPOSE" up --build --exit-code-from testclient; then
    echo "[PASS] $runtime_image | $builder_image"
    PASSED_IMAGES+=("$runtime_image | $builder_image")
  else
    echo "[FAIL] $runtime_image | $builder_image "
    FAILED_IMAGES+=("$runtime_image | $builder_image")
  fi

}

# Add newline if not already present

cleanup_all
generate_certs
sleep 2
if [ -s "$IMAGE_LIST" ] && [ -n "$(tail -c1 "$IMAGE_LIST")" ]; then
  echo >> "$IMAGE_LIST"
fi

# Main loop
while IFS="#" read -r runtime_image builder_image; do
  [[ -z "$runtime_image" ]] && continue
  run_test_for_config "$runtime_image" "$builder_image"
done < "$IMAGE_LIST"
cleanup_all
# Restore original files
echo ""
echo "[INFO] Restoring original Dockerfile..."
mv "${DOCKERFILE_ORIG}${BACKUP_SUFFIX}" "$DOCKERFILE_ORIG"
echo "[INFO] Removing backup Dockerfiles..."
rm -f *.backup*

# Summary
echo
echo "==================== TEST SUMMARY ===================="
echo "✅ Passed images:"
for img in "${PASSED_IMAGES[@]}"; do
  echo "  - $img"
done

echo
echo "❌ Failed images:"
for img in "${FAILED_IMAGES[@]}"; do
  echo "  - $img"
done

if [ "${#FAILED_IMAGES[@]}" -gt 0 ]; then
  echo "[SUMMARY] Some tests failed."
  exit 1
else
  echo "[SUMMARY] All tests passed!"
  exit 0
fi

#!/usr/bin/env bash
set -euo pipefail

main() {
  local workspace="${GITHUB_WORKSPACE:-$PWD}"

  docker run --rm \
    -v "${workspace}:${workspace}" \
    -w "${workspace}" \
    -e NIX_SSL_CERT_FILE="${NIX_SSL_CERT_FILE:-}" \
    -e SSL_CERT_FILE="${SSL_CERT_FILE:-}" \
    -e CURL_CA_BUNDLE="${CURL_CA_BUNDLE:-}" \
    -e TERM="${TERM:-}" \
    -e SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-}" \
    -e GITHUB_TOKEN="${GITHUB_TOKEN:-}" \
    -e GITHUB_OWNER="${GITHUB_OWNER:-}" \
    -e IDENTIFIER="${IDENTIFIER:-}" \
    -e ZONE="${ZONE:-}" \
    -e ACME_SERVER_URL="${ACME_SERVER_URL:-}" \
    -e RANCHER_INSECURE="${RANCHER_INSECURE:-}" \
    ghcr.io/rancher/ci-image/nix:20260603-18 \
    bash .github/workflows/scripts/nix-run.sh "$@"
}

main "$@"

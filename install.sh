#!/usr/bin/env bash

set -ex

flake = "legion"
source ./scripts/setup.sh
nixos-install --flake .#$flake

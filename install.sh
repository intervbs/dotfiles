#!/usr/bin/env bash

set -ex

source ./scripts/setup.sh
nixos-install --flake .#legion

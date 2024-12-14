#!/usr/bin/env bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

nix develop $SCRIPT_DIR --override-input acados-overlay $SCRIPT_DIR/../ 
#!/bin/bash
set -x
test -f "$1" && echo "exists" || echo "not found"

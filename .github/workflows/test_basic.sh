#!/usr/bin/env bash

# Simple test suite
set -e

echo "Testing gh-switch..."

# Test init
./bin/gh-switch init
[ -d "$HOME/.config/gh-switch" ] || exit 1

# Test add (with mock input)
echo -e "~/.ssh/test\nTest User\ntest@example.com\ntestuser\n" | ./bin/gh-switch add test

# Test list
./bin/gh-switch list | grep -q "test" || exit 1

# Test use
./bin/gh-switch use test --global

# Test current
./bin/gh-switch current | grep -q "test" || exit 1

echo "All tests passed!"
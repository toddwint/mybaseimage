#!/usr/bin/env bash
docker buildx create --name multi-platform-builder --platform linux/arm64,linux/amd64 --bootstrap --use

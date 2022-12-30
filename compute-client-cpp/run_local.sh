#!/bin/sh

STATIC_DIR="$(pwd)/static"

bazel run --cxxopt=-std=c++20 clients:main --\
    --project_name="interlocked" \
    --http_server_static_serving_path="${STATIC_DIR}" \
    --http_server_port=8080 \
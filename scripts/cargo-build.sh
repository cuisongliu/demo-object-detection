#!/bin/bash

set -ex

source "$HOME/.cargo/env"

CURRENT="$(realpath "$(dirname -- "$0")")"
WASI_SYSROOT="${CURRENT}/../assets/wasi-sysroot"
export BINDGEN_EXTRA_CLANG_ARGS="--sysroot=${WASI_SYSROOT} --target=wasm32-wasi -fvisibility=default"

pushd "${CURRENT}/.."

# default features (audio,text,vision)
cargo build --target wasm32-wasi --release
wasmedge compile target/wasm32-wasi/release/demo-object-detection.wasm demo-object-detection.wasm
wasmedge --dir .:. demo-object-detection.wasm example.jpg output.jpg
popd

FROM gcr.io/skia-public/basealpine:3.8

COPY . /
COPY --from=gcr.io/skia-public/skia-wasm-release:prod \
  /tmp/debugger/debugger.wasm \
  /usr/local/share/debugger-assets/res/
COPY --from=gcr.io/skia-public/skia-wasm-release:prod \
  /tmp/debugger/debugger.js \
  /usr/local/share/debugger-assets/res/js/

USER skia

ENTRYPOINT ["/usr/local/bin/debugger-assets"]
CMD ["--logtostderr", "--resources_dir=/usr/local/share/debugger-assets"]

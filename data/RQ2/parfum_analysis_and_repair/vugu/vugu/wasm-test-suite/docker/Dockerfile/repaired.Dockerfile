FROM chromedp/headless-shell:latest

RUN apt-get update && apt-get install -y --no-install-recommends dumb-init && rm -rf /var/lib/apt/lists/*;

COPY wasm-test-suite-srv /bin/wasm-test-suite-srv
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /bin/wasm-test-suite-srv /entrypoint.sh

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/entrypoint.sh"]

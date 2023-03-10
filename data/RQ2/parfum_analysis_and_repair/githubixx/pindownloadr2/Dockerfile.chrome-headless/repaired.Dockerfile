FROM chromedp/headless-shell:78.0.3904.97

RUN apt install -y --no-install-recommends dumb-init && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["dumb-init", "--"]

# If getting "out of memory" errors "--disable-dev-shm-usage" might help
CMD ["/headless-shell/headless-shell", "--no-sandbox", "--remote-debugging-address=0.0.0.0", "--remote-debugging-port=9222", "--disable-gpu", "--headless", "--disable-dev-shm-usage"]

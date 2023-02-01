FROM ubuntu:16.04
RUN apt-get update -y && apt-get install --no-install-recommends -y chromium-browser curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir /app && chmod 777 /app
ADD .  /app
WORKDIR /app
RUN chmod +x /usr/bin/chromium-browser
ENTRYPOINT ["/bin/bash"]
CMD ["-c", "export LIGHTHOUSE_CHROMIUM_PATH=/usr/bin/chromium-browser && /usr/bin/chromium-browser --no-sandbox --remote-debugging-port=9222 --disable-gpu --headless"]
#
# docker exec -it chromeless nodejs chrome-headless-print.js
#

FROM node:17

# install many dependencies for headless chromium
RUN apt-get update \
  && apt-get install --no-install-recommends -y libasound2 libatk1.0-0 libcups2 libgconf-2-4 \
  libgtk-3-0 libnss3 libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 \
  libxi6 libxrandr2 libxss1 libxtst6 && rm -rf /var/lib/apt/lists/*;

VOLUME ["/brainbox"]
ADD start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/start.sh"]

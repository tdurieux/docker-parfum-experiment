FROM node:10

# https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker

# See https://crbug.com/795759
RUN apt-get update && apt-get install --no-install-recommends -yq libgconf-2-4 && rm -rf /var/lib/apt/lists/*;

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      fonts-noto fonts-noto-cjk fonts-ocr-b \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /src/*.deb

# It's a good idea to use dumb-init to help prevent zombie chrome processes.
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Uncomment to skip the chromium download when installing puppeteer. If you do,
# you'll need to launch puppeteer with:
#     browser.launch({executablePath: 'google-chrome-unstable'})
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true



# Build and deploy the app.
COPY . /build
WORKDIR /build
RUN bash ./scripts/ci-install.sh \
    && bash ./scripts/build.sh \
    && mkdir -p /home/pptruser/user-data/Downloads \
    && mkdir -p "/home/pptruser/user-data/Default/Code Cache/js" \
    && mkdir -p /home/pptruser/user-data/Default/GPUCache \
    && mkdir -p /home/pptruser/user-data/Default/Cache \
    && mv ./packages/_debug_app /home/pptruser/app \
    && cd /home/pptruser/app \
    && rm -rf ./node_modules \
    && npm ci --production \
    && rm -rf /build \
    && npm cache clean --force \
    && rm -rf /tmp/*



# Add user so we don't need --no-sandbox.
RUN groupadd -r pptruser \
    && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser

# Run everything after as non-privileged user.
USER pptruser

# Set chromium executable path for puppeteer.
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-unstable

WORKDIR /home/pptruser/app
EXPOSE 3000
ENTRYPOINT [ "dumb-init", "--" ]
CMD [ "node", "dist/app.js", "--express-docker" ]

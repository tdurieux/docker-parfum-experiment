FROM local/webpack-builder

ENV APP_HOME /usr/src/app/
ENV NODE_ENV test
# Use real chrome because chromium became a snap in focal
ENV CHROME_BIN /usr/bin/google-chrome

USER root
RUN apt-get update --quiet=2 \
 && curl -f -LOs https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
 && apt-get install --no-install-recommends --quiet=2 -y ./google-chrome-stable_current_amd64.deb \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ./google-chrome-stable_current_amd64.deb

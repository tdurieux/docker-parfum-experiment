FROM node:10-slim as build
EXPOSE 3000

# Install latest chrome
RUN apt-get update \
  && apt-get install --no-install-recommends -y wget gnupg gnupg1 gnupg2 \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /src/*.deb

RUN groupadd -r 18xx && useradd -r -g 18xx -G audio,video 18xx \
  && mkdir -p /home/18xx/Downloads \
  && chown -R 18xx:18xx /home/18xx

USER 18xx
WORKDIR /home/18xx

COPY --chown=18xx:18xx package.json /home/18xx/
COPY --chown=18xx:18xx yarn.lock /home/18xx

# Install Deps
RUN yarn

# Copy site code
COPY --chown=18xx:18xx . /home/18xx
VOLUME /home/18xx

# Command that runs
ENTRYPOINT ["yarn"]
CMD ["start"]

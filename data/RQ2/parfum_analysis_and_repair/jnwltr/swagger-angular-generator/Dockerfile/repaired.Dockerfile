FROM node:10-stretch

RUN apt-get update && \
    apt-get install --no-install-recommends -y git wget build-essential && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg --unpack google-chrome-stable_current_amd64.deb && \
    apt-get install -f -y && \
    apt-get clean && \
    rm google-chrome-stable_current_amd64.deb && rm -rf /var/lib/apt/lists/*;

# Font libraries
RUN apt-get -qqy --no-install-recommends install fonts-ipafont-gothic xfonts-100dpi xfonts-75dpi xfonts-cyrillic xfonts-scalable libfreetype6 libfontconfig && rm -rf /var/lib/apt/lists/*;

RUN mkdir /code
WORKDIR /code
COPY . /code

RUN chown -R node:node /code
USER node

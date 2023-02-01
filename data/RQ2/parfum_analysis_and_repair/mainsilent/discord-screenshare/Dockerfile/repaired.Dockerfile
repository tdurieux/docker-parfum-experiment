FROM ubuntu:20.04

# Install dependencies
RUN apt-get update
RUN apt-get install --no-install-recommends -y curl git unzip wget && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm i -g yarn && npm cache clean --force;

# Clone Repo
RUN git clone https://github.com/MainSilent/Discord-Screenshare.git
WORKDIR Discord-Screenshare
RUN yarn install && yarn cache clean;
COPY .env .

# Install chrome 88
RUN wget https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_88.0.4324.96-1_amd64.deb
RUN apt-get install --no-install-recommends -y ./google-chrome-stable_88.0.4324.96-1_amd64.deb && rm -rf /var/lib/apt/lists/*;

# Install chromedriver 88
RUN wget https://chromedriver.storage.googleapis.com/88.0.4324.27/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN mv chromedriver /bin

# Start Bot
RUN yarn start
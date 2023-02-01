FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --reinstall libgtk2.0-0 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgbm-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libnss3 libnss3-tools libxss1 libgtk-3-0 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends chromium-browser -y && rm -rf /var/lib/apt/lists/*;
# To allow MP3 conversion
RUN apt-get install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;

COPY index.js /index.js
COPY episode.json /episode.json
# used by nmp ci
COPY package-lock.json /package-lock.json
COPY package.json /package.json
COPY entrypoint.sh /entrypoint.sh

RUN chmod 777 /entrypoint.sh
ENV LC_ALL=en_US.UTF-8

ENTRYPOINT [ "/entrypoint.sh" ]

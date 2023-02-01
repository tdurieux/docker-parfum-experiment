FROM ubuntu:18.04
# https://rtfm.co.ua/en/docker-configure-tzdata-and-timezone-during-build/
ENV TZ=Asia/Kolkata
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update -y

# Install Node.js
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gnupg-agent && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -f --silent --location https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;
RUN node --version
RUN yarn --version && yarn cache clean;

RUN apt-get install --no-install-recommends -y qpdf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3.8 && rm -rf /var/lib/apt/lists/*;
RUN python3 --version
RUN apt-get install --no-install-recommends -y python3-tk ghostscript && rm -rf /var/lib/apt/lists/*;
RUN gs -version
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir 'opencv-python==4.2.0.34'
RUN pip3 install --no-cache-dir "camelot-py[cv]"

WORKDIR /codebase
COPY package.json ./
COPY yarn.lock ./
COPY . ./
COPY .env.docker.local ./.env.local
RUN yarn && yarn build && yarn cache clean;
EXPOSE 3000
CMD ["yarn", "start"]
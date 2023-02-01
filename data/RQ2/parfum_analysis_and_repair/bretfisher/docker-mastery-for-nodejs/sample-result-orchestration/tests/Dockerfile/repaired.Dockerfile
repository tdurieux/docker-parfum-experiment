FROM node:8.9-slim

RUN apt-get update -qq
    && apt-get install -qy --no-install-recommends \ 
    ca-certificates \
    bzip2 \
    curl \
    libfontconfig \
    && rm -rf /var/lib/apt/lists/*
RUN yarn global add phantomjs-prebuilt && yarn cache clean;
ADD . /app
WORKDIR /app
CMD ["/app/tests.sh"]

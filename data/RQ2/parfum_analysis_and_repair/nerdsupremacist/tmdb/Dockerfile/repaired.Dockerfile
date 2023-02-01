FROM swift:5.3
WORKDIR /app
ADD . ./

ARG API_KEY
ENV API_KEY=$API_KEY

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libz-dev && rm -rf /var/lib/apt/lists/*;

RUN swift package clean

RUN swift build -Xswiftc -g -Xlinker -E -Xcc -v -Xcxx -v

EXPOSE 8080
ENTRYPOINT ["./.build/debug/tmdb"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0"]

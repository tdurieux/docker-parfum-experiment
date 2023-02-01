FROM node:13-slim

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
RUN apt-get update && apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
EXPOSE 3000
COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

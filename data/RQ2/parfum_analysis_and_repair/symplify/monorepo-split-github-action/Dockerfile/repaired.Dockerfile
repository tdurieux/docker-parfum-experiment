# THIS IS BASE IMAGE
FROM php:8.0-cli

RUN apt-get update -y && apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

# directory inside docker
WORKDIR /splitter

# make local content available inside docker - copies to /splitter
COPY . .

# see https://nickjanetakis.com/blog/docker-tip-86-always-make-your-entrypoint-scripts-executable
ENTRYPOINT ["php", "/splitter/entrypoint.php"]

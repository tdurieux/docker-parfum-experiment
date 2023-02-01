FROM arm64v8/debian:buster

RUN apt-get update && apt-get install --no-install-recommends -y php7.3-cli php7.3-dev php7.3-bcmath composer phpunit curl git valgrind && apt-get clean && rm -rf /var/lib/apt/lists/*;

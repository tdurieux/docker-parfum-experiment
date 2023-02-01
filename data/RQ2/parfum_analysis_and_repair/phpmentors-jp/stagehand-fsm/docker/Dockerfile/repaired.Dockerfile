FROM phpmentors/php-app:php72

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update -y && apt-get install --no-install-recommends -y less unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y

# Other tools


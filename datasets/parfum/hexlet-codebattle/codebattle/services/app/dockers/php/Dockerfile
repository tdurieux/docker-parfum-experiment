FROM php:8.1.1-cli

RUN apt-get update && apt-get install -y build-essential --no-install-recommends && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

ADD checker_example.php .
ADD solution_example.php .
ADD Makefile .

FROM kylef/swiftenv
RUN swiftenv install 3.1

RUN apt-get -qq update && apt-get install --no-install-recommends -y openssl libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
WORKDIR /app

ADD Package.swift /app/Package.swift
ADD Package.pins /app/Package.pins
ADD Package.resolved /app/Package.resolved
RUN swift package fetch
ADD . /app

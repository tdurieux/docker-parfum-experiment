# -*- dockerfile -*-
FROM ubuntu:trusty
RUN apt-get update -y && apt-get install --no-install-recommends -y gcc g++ libpoppler-glib-dev && rm -rf /var/lib/apt/lists/*;


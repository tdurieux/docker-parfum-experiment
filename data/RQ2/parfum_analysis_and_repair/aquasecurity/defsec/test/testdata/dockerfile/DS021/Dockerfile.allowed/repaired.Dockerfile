FROM node:12
USER mike
RUN apt-get -fmy --no-install-recommends install apt-utils && apt-get clean && rm -rf /var/lib/apt/lists/*;
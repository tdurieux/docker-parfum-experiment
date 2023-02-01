FROM node:12
USER mike
RUN apt-get install -y --no-install-recommends apt-utils && apt-get clean && rm -rf /var/lib/apt/lists/*;
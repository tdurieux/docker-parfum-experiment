FROM node:14.4.0

RUN apt-get update && apt-get install --no-install-recommends -y xvfb libxi-dev libgl1-mesa-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

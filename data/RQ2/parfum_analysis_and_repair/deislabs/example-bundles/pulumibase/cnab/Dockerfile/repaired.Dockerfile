FROM node:latest

RUN apt-get update && apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

# this is currently the official installation guide for Linux
RUN curl -fsSL https://get.pulumi.com | sh

COPY app /cnab/app

# add the pulumi bin directory to the path
ENV PATH="/root/.pulumi/bin:${PATH}"

FROM ubuntu:14.04
RUN apt-get update -qq && apt-get install --no-install-recommends -qq -y openjdk-7-jre-headless && rm -rf /var/lib/apt/lists/*;


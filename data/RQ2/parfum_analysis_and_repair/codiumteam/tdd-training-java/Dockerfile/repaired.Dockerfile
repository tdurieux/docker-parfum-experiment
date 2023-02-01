FROM maven:3.6-openjdk-8

RUN apt update && apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
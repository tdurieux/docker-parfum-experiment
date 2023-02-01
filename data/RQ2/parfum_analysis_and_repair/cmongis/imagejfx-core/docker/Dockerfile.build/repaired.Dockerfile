FROM airdock/oraclejdk:1.8

RUN apt-get update && apt-get install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;
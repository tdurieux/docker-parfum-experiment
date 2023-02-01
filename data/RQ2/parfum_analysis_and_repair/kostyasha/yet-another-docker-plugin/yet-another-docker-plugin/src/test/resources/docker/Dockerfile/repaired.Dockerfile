FROM java:openjdk-8u66-jdk
RUN apt-get update && apt-get install --no-install-recommends -y git maven && rm -rf /var/lib/apt/lists/*;


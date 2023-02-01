FROM java:8-jdk

RUN apt-get update && apt-get install --no-install-recommends -y ant && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;

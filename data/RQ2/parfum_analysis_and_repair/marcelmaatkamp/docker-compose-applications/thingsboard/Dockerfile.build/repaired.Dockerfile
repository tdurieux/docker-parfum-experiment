FROM frekele/maven:latest

RUN apt-get update && apt-get install --no-install-recommends -y build-essential curl git unzip wget axel telnet vim && \
    rm -rf /var/lib/apt/lists/* && \
    curl -f -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

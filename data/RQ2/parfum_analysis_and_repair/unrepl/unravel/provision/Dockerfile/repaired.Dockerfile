FROM openjdk:latest

RUN curl -f -sL https://deb.nodesource.com/setup_9.x | bash - && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN curl -f --silent --show-error https://download.clojure.org/install/linux-install-1.9.0.273.sh | bash -

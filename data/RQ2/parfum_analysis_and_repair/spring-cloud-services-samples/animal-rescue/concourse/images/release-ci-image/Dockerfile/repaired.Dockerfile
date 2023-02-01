FROM ubuntu:bionic-20181018

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates net-tools git curl jq wget gnupg2 && rm -rf /var/lib/apt/lists/*;

# Install CF CLI
RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -
RUN echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
RUN apt-get update && apt-get install --no-install-recommends -y cf-cli && rm -rf /var/lib/apt/lists/*;

# Install Node
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install Java
ENV JAVA_HOME /opt/openjdk
ENV PATH $JAVA_HOME/bin:$PATH
RUN mkdir -p /opt/openjdk && \
    cd /opt/openjdk && \
    curl -f -L https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u192-b12/OpenJDK8U-jdk_x64_linux_hotspot_8u192b12.tar.gz | tar xz --strip-components=2

ADD https://raw.githubusercontent.com/spring-io/concourse-java-scripts/v0.0.2/concourse-java.sh /opt/

# Install dependencies for Cypress (https://docs.cypress.io/guides/guides/continuous-integration.html#Dependencies)
RUN apt-get install --no-install-recommends -y libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*

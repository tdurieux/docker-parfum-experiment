FROM maven:3.5-jdk-8-slim

ARG OPENAPI_GENERATOR_COMMIT
ARG OPENAPI_GENERATOR_USER_ORG=OpenAPITools

# Install preprocessing script requirements
RUN apt-get update && apt-get -y --no-install-recommends install git python-pip && pip install --no-cache-dir urllib3==1.24.2 && rm -rf /var/lib/apt/lists/*;

# Install Autorest
RUN apt-get update && apt-get -qq --no-install-recommends -y install libunwind8 libicu57 libssl1.0 liblttng-ust0 libcurl3 libuuid1 libkrb5-3 zlib1g gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && apt-get -y --no-install-recommends install \
    nodejs \
    libunwind8-dev \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g autorest@3 && npm cache clean --force;

# Check out specific commit of openapi-generator
RUN mkdir /source && \
    cd /source && \
    git clone -n https://github.com/${OPENAPI_GENERATOR_USER_ORG}/openapi-generator.git && \
    cd openapi-generator && \
    git checkout $OPENAPI_GENERATOR_COMMIT

# Build it and persist local repository
RUN mkdir /.npm && chmod -R go+rwx /.npm && chmod -R go+rwx /root && umask 0 && cd /source/openapi-generator && \
    mvn install -DskipTests -Dmaven.test.skip=true -pl modules/openapi-generator-maven-plugin -am && \
    cp -r /root/.m2/* /usr/share/maven/ref

RUN mkdir -p /node_modules && chmod -R go+rwx /node_modules
RUN npm install @microsoft.azure/autorest.csharp \
                @microsoft.azure/autorest.modeler && npm cache clean --force;

RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor > microsoft.asc.gpg
RUN mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
RUN curl -f https://packages.microsoft.com/config/debian/9/prod.list > prod.list
RUN mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
RUN chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
RUN chown root:root /etc/apt/sources.list.d/microsoft-prod.list

RUN apt-get update
RUN apt-get install --no-install-recommends -yy -q dotnet-hosting-2.0.8 && rm -rf /var/lib/apt/lists/*;
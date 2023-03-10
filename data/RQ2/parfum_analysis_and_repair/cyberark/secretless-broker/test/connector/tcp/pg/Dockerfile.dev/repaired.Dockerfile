FROM secretless-dev

RUN apt-get update && \
    apt-get install --no-install-recommends -y postgresql-client \
                       postgresql-contrib && rm -rf /var/lib/apt/lists/*;

RUN go get github.com/ajstarks/svgo/benchviz && \
    go get golang.org/x/tools/cmd/benchcmp

# Add java8 and add to $PATH
# Fix certificate issues
RUN apt-get update && \
    apt-get install --no-install-recommends -y ant \
                       ca-certificates-java \
                       software-properties-common && \
    apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main' && \
    apt-get update && \
    apt-get install --no-install-recommends -y openjdk-8-jdk && \
    apt-get clean && \
    update-ca-certificates -f && rm -rf /var/lib/apt/lists/*;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

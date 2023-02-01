FROM swift:5.6.1


# Update, upgrade and install a few useful tools

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends unzip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends zip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;


# Install Kotlin 1.3.61

### Inspired by https://hub.docker.com/r/jujhars13/docker-kotlin/~/dockerfile/
### and https://stackoverflow.com/questions/24085978/github-url-for-latest-release-of-the-download-file

RUN wget $( curl -f -s https://api.github.com/repos/JetBrains/kotlin/releases/latest | grep 'browser_download_url' | grep 'compiler' | cut -d\" -f4) -O /tmp/kotlin.zip && \
    unzip /tmp/kotlin.zip -d /opt && \
    rm /tmp/kotlin.zip
ENV PATH $PATH:/opt/kotlinc/bin


# Install Java 8

### From https://stackoverflow.com/questions/36587850/best-way-to-install-java-8-using-docker
RUN apt-get install -y --no-install-recommends software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openjdk-8-jre && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --config java
RUN update-alternatives --config javac


# Set the working directory

WORKDIR /app/Gryphon

# Build with: docker build -t gryphon .
# Run with: docker run -it --rm --privileged -v /path/to/Gryphon/:/app/Gryphon gryphon

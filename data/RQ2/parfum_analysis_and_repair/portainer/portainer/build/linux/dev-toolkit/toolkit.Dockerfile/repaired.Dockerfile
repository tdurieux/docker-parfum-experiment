FROM ubuntu:20.04

# Expose port for the Portainer UI and Edge server
EXPOSE 9000
EXPOSE 9443
EXPOSE 8000

WORKDIR /src/portainer

# Set TERM as noninteractive to suppress debconf errors
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Set default go version
ARG GO_VERSION=go1.17.6.linux-amd64

# Install packages
RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends -qq \
	dialog \
	apt-utils \
	curl \
	build-essential \
	git \
	wget \
	apt-transport-https \
	ca-certificates \
	gnupg-agent \
	software-properties-common && rm -rf /var/lib/apt/lists/*;

# Install Docker CLI
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
	&& add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable" \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y docker-ce-cli && rm -rf /var/lib/apt/lists/*;


# Install NodeJS
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
	&& apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install Yarn
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
	&& apt-get update && apt-get -y --no-install-recommends install yarn && rm -rf /var/lib/apt/lists/*;

# Install Golang
RUN cd /tmp \
	&& wget -q https://dl.google.com/go/${GO_VERSION}.tar.gz \
	&& tar -xf ${GO_VERSION}.tar.gz \
	&& mv go /usr/local && rm ${GO_VERSION}.tar.gz

# Copy run script
COPY run.sh /
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]

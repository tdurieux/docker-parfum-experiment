FROM ubuntu:20.04

# install tzdata first to prevent 'geographic area' prompt
RUN apt-get update >/dev/null \
	&& apt-get install --no-install-recommends -y tzdata \
	&& apt-get install --no-install-recommends -y git curl && rm -rf /var/lib/apt/lists/*;

# install npm-groovy-lint
RUN apt-get install --no-install-recommends -y default-jre \
	&& curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
	&& apt-get install --no-install-recommends -y nodejs \
	&& npm install -g npm-groovy-lint && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# install python
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

# install shellcheck and gitlint
RUN apt-get install --no-install-recommends -y shellcheck \
	&& pip install --no-cache-dir gitlint && rm -rf /var/lib/apt/lists/*;

# install ripgrep and yamllint
RUN apt-get install --no-install-recommends -y ripgrep \
	&& pip install --no-cache-dir yamllint && rm -rf /var/lib/apt/lists/*;

# add ubuntu user (used by jenkins)
RUN useradd --uid 1000 -ms /bin/bash ubuntu
ENV PATH=$PATH:/home/ubuntu/.local/bin

WORKDIR /home/ubuntu

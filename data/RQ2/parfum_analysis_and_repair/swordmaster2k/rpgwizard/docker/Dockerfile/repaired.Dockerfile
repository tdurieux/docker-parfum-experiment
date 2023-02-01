# Xubuntu Docker for testing
FROM consol/ubuntu-xfce-vnc
ENV REFRESHED_AT 2018-03-18

# Switch to root user to install additional software
USER 0

# Update package listings
RUN apt-get -yq update

# Install add-apt-repository
RUN apt-get -yq --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;

# Install a Java
RUN add-apt-repository ppa:openjdk-r/ppa && apt-get -yq update && apt-get -yq --no-install-recommends install openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;

# Install npm
RUN apt-get install --no-install-recommends -yq curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -yq nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g jshint && npm cache clean --force;

# Switch back to default user
USER 1000
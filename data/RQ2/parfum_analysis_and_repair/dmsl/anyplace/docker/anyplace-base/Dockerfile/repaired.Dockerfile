FROM ubuntu:18.04

# Dont allow interactivity when building image
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Configuring timezone" \
	&& ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
	&& echo 'Europe/Athens' > /etc/timezone

RUN echo "Installing docker-related dependencies"  \
	&& apt-get update -y \
	&& apt-get upgrade -y \
        && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

# Installing docker-related dependencies (and some debug tools)
RUN echo "Installing docker-related dependencies" \
        && apt-get install --no-install-recommends -y pwgen \
        iputils-ping telnet \
        gnupg curl default-jdk \
        php php-common gcc imagemagick advancecomp python-minimal \
        zip unzip && rm -rf /var/lib/apt/lists/*;


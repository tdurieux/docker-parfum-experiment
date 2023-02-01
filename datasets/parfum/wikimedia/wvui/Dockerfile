FROM docker-registry.wikimedia.org/nodejs12-devel:0.0.1
RUN apt-get update && \
	apt-get install -y \
		build-essential \
		openssh-server \
		python \
		pkg-config \
		git

# Create user with same ID as our host machine so Docker generated files are owned by us
ARG UID=1000
ARG GID=1000
ARG HOST

# Note: Adding existing group from host causes error on MacOS
RUN if [ "$HOST" = "Linux" ] ; then addgroup --gid $GID runuser ; fi
RUN adduser --uid $UID --gid $GID --disabled-password --gecos "" runuser

RUN mkdir -p /home/runuser/.ssh
RUN echo "Host gerrit.wikimedia.org \n\t IdentityFile /run/secrets/ssh_key" > /home/runuser/.ssh/config

USER runuser

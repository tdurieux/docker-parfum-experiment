FROM ubuntu:18.04

RUN \
	apt-get update && \
	apt-get -y upgrade && \
	apt-get install --no-install-recommends -y gnupg gnupg2 ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
	echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
	apt-get update && \
	apt-get -y upgrade && \
	apt-get install --no-install-recommends -y mono-devel && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
COPY Server.cs .
COPY Client.cs .
COPY Remote.cs .
COPY Makefile .
RUN make
COPY success .

EXPOSE 10
CMD ["/usr/bin/mono", "/usr/src/app/Server.exe"]

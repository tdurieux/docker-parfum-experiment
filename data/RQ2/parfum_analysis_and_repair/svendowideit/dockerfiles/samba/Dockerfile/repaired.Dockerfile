FROM		debian:stable
LABEL		CMDBUILD="docker build -t svendowideit/samba https://raw.githubusercontent.com/SvenDowideit/dockerfiles/master/samba/Dockerfile"
LABEL		CMDRUN="docker run svendowideit/samba"

MAINTAINER	Sven Dowideit <SvenDowideit@docker.com> (@SvenDowideit)

# gettext for envsubst
RUN apt-get update && \
			apt-get install --no-install-recommends -yq samba gettext && rm -rf /var/lib/apt/lists/*;
ADD		share.tmpl /share.tmpl
ADD		setup.sh /setup.sh

ENTRYPOINT      ["/setup.sh"]

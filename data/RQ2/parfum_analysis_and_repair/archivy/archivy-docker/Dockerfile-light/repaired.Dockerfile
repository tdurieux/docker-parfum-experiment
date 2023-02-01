########    Dockerfile for Archivy Built On Alpine Linux     ########
#                                                                   #
#####################################################################
#        CONTAINERISED ARCHIVY BUILT ON TOP OF ALPINE LINUX         #
#####################################################################
#   The only difference between `Dockerfile-light` and `Dockerfile` # 
#   is that                                                         #
#   this image comes with a more lightweight configuration for      #
#   use with ripgrep                                                #
#####################################################################


FROM python:3.9-alpine
# Archivy version
ARG VERSION

# ARG values for injecting metadata during build time
# NOTE: When using ARGS in a multi-stage build, remember to redeclare
#       them for the stage that needs to use it. ARGs last only for the
#       lifetime of the stage that they're declared in.
ARG BUILD_DATE
ARG VCS_REF

# Archivy version
ARG VERSION

# Installing xdg-utils and pandoc
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update && apk add --no-cache \
        build-base \
		ripgrep \
		libxml2-dev \
		libxslt-dev \
	&& pip3.9 install archivy==$VERSION \
    # Creating non-root user and group for running Archivy
    && addgroup -S -g 1000 archivy \
    && adduser -h /archivy -g "User account for running Archivy" \
    -s /sbin/nologin -S -D -G archivy -u 1000 archivy \
    # Creating directory in which Archivy's files will be stored
    # (If this directory isn't created, Archivy exits with a "permission denied" error)
    && mkdir -p /archivy/data \
    && mkdir -p /archivy/.local/share/archivy \
    # Changing ownership of all files in user's home directory
    && chown -R archivy:archivy /archivy

# Copying pre-generated config.yml from host
COPY --chown=archivy:archivy config-lite.yml /archivy/.local/share/archivy/config.yml

# Run as user 'archivy'
USER archivy

# Exposing port 5000
EXPOSE 5000

# System call signal that will be sent to the container to exit
STOPSIGNAL SIGTERM

ENTRYPOINT ["archivy"]

# The 'run' CMD is required by the 'entrypoint.sh' script to set up the Archivy server. 
# Any command given to the 'docker container run' will override the CMD below.
CMD ["run"]

# Labels
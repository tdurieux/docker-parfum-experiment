FROM ubuntu:xenial

RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs build-essential git-all && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_4.x | bash


ARG SERVER_FILES=freedom-social-quiver-server
COPY ${SERVER_FILES} /quiver/freedom-social-quiver-server/

EXPOSE 3000

ENTRYPOINT PORT=3000 DEBUG=stats nodejs /quiver/freedom-social-quiver-server/app.js

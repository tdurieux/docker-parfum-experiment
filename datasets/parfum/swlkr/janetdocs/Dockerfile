FROM alpine:3.7

RUN apk add --no-cache build-base curl curl-dev git

# Create a non-root user to run the app as
ARG USER=app
ARG GROUP=app
ARG UID=1101
ARG GID=1101

RUN addgroup -g $GID -S $GROUP
RUN adduser -u $UID -S $USER -G $GROUP

# Move to tmp and install janet
RUN git clone https://github.com/janet-lang/janet.git /tmp/janet && \
    cd /tmp/janet && \
    make all test install

RUN chmod 777 /usr/local/lib/janet

# Use jpm to install joy
RUN jpm install joy

RUN chown -R $USER:$GROUP /usr/local/lib/janet

# Create a place to mount or copy in your server
RUN mkdir -p /var/app
RUN chown -R $USER:$GROUP /var/app

USER $USER
WORKDIR /var/app
COPY . ./

ARG DEPS=false
USER root
RUN jpm deps
USER $USER

EXPOSE 9003

CMD ["janet", "main.janet"]

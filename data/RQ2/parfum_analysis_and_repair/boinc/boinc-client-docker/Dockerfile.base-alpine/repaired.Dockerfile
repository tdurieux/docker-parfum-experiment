##########################################################################################
# IMPORTANT: Alpine uses musl instead of glibc, therefore projects might not support it. #
##########################################################################################

FROM alpine:edge

LABEL maintainer="BOINC" \
      description="Alpine base image for lightweight BOINC client."

# Global environment settings
ENV BOINC_GUI_RPC_PASSWORD="123" \
    BOINC_REMOTE_HOST="127.0.0.1" \
    BOINC_CMD_LINE_OPTIONS=""

# Copy files
COPY bin/ /usr/bin/

# Configure
WORKDIR /var/lib/boinc

# BOINC RPC port
EXPOSE 31416

# Install
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
# Install Time Zone Database
	tzdata \
# Install BOINC Client
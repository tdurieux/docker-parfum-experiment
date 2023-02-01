FROM alpine:latest

# Copy Startup Script
COPY start.sh /start.sh

# Install IP Tables & fix permissions
RUN apk update \
    && apk add --no-cache tzdata \
    && apk add --no-cache bash \
    && apk add --no-cache curl \
    && apk add iptables --no-cache > /dev/null && \
    chmod +x /start.sh

WORKDIR /

# Run script
CMD [ "/start.sh" ]
FROM alpine:3.10
LABEL maintainer="Christronyxyocum and Starbix"

# Env variables for Discord token, command prefix, config path, UID, & GID
ENV TOKEN="$TOKEN_HERE"
ENV PREFIX="$PREFIX_HERE"
ENV CONFIG_PATH="$PATH_HERE"
ENV UID=991
ENV GID=991

# Copy files
COPY rootfs /

# Install some required packages
RUN apk add -U build-base \
				libssl1.0 \
				curl \
				git \
				su-exec \
				s6 \
				python \
				npm \
		# Create dir and clone MediaButler
		&& mkdir -p /opt \
		&& cd /opt \
		&& git clone https://github.com/MediaButler/MediaButler.git \
		# Copy settings example to settings
		&& cd MediaButler \
		&& cp ./settings.example.json ./settings.json \
		# Install
		&& npm install \
		# Set permissions
		&& chmod a+x /usr/local/bin/* /etc/s6.d/*/* \
		# Cleanup
		&& apk del build-base \
		&& rm -rf /tmp/* /var/cache/apk/*

# Add config path volume
VOLUME /config

# Execute run.sh script
CMD ["run.sh"]

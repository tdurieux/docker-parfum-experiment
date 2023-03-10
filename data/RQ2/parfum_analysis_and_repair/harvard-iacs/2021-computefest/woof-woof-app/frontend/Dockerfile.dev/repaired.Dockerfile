FROM node:14.9.0-buster-slim

# Ensure we don't run the app as root.
RUN set -ex; \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends openssl && \
    useradd -ms /bin/bash app -d /home/app -G sudo -u 2000 -p "$(openssl passwd -1 Passw0rd)" && \
    mkdir -p /app && \
    chown app:app /app && rm -rf /var/lib/apt/lists/*;

EXPOSE 3000

# Switch to the new user
USER app
WORKDIR /app

# Install python packages
ADD --chown=app:app package.json package-lock.json /app/
RUN npm install && npm cache clean --force;

ADD --chown=app:app . /app


ENTRYPOINT ["/bin/bash"]
FROM ubuntu:latest

# Add User/Group and make User owner of the root directory
RUN groupadd -r listarr \
    && useradd -r -s /bin/false -g listarr listarr

# Install Node.js and dependencies
RUN apt-get update -yq \
    && apt-get install --no-install-recommends curl gnupg gosu -yq \
    && curl -f -sL https://deb.nodesource.com/setup_14.x | bash \
    && apt-get install --no-install-recommends nodejs -yq \
    && mkdir -p /app/server/config \
    && chown -R listarr:listarr /app && rm -rf /var/lib/apt/lists/*;

# Copy and Setup App
WORKDIR /app
VOLUME /app/server/config
COPY . /app
RUN npm run setup \
    && chmod +x docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]

EXPOSE 5000
CMD ["npm", "start"]
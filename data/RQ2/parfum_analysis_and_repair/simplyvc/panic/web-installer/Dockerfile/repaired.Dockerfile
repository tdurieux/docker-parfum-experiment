FROM node:16

# Create app directory
WORKDIR /opt/panic

# Change directory, and copy all installer contents from the host to the
# container.
WORKDIR ./web-installer
COPY ./web-installer ./

ENV GENERATE_SOURCEMAP=false

# RUN npm install
RUN npm ci --include=dev

# Build installer
RUN npm run-script build --only=production

# Expose port
EXPOSE 8000

# Tool which waits for dependent containers
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.2.1/wait /wait
RUN chmod +x /wait

CMD /wait && bash run_installer_server.sh
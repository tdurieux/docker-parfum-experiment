FROM node:4.2.2

# Install location
ENV dir /opt/ldf-client

# Copy the client files
ADD . ${dir}

# Install the node module
RUN cd ${dir} && npm install && npm cache clean --force;

# Run base binary
WORKDIR ${dir}
ENTRYPOINT ["node", "bin/ldf-client"]

# Default command
CMD ["--help"]


FROM astefanutti/decktape
USER root
RUN apt update -q && \
	apt install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;
USER node
RUN npm install decktape && npm cache clean --force;

FROM node:17

# Install gettext for envsubst
RUN apt-get update && apt-get install --no-install-recommends -y gettext-base && rm -rf /var/lib/apt/lists/*;

ADD deploy.sh /

ENTRYPOINT [ "/deploy.sh" ]
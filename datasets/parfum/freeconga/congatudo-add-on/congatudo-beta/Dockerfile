FROM adrigzr/valetudo-conga:homeassistant-2022.02.0-conga.0

# Change user to root
USER root

# Change workdir
WORKDIR /usr/src/app

# Setup environment
ENV VALETUDO_CONFIG_PATH=/config/valetudo.json

# Copy script
COPY valetudo.sh valetudo.sh
RUN chmod a+x valetudo.sh

# Run script
CMD ["dumb-init", "./valetudo.sh"]

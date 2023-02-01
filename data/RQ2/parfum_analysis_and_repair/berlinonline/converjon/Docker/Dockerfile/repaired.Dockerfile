################################################################################
# Base image
################################################################################

FROM node:boron

################################################################################
# Build instructions
################################################################################

RUN apt-get update && apt-get install --no-install-recommends -y \
    imagemagick \
    libimage-exiftool-perl && rm -rf /var/lib/apt/lists/*;

RUN npm install -g converjon && npm cache clean --force;
EXPOSE 8000
ENV USE_CONFIG_DIR=false
COPY start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/bin/bash", "/start.sh"]

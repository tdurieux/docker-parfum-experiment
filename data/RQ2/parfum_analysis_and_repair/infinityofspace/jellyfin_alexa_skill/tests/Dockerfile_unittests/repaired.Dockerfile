# Attention: this is a image for unittest and not for normal use!

FROM jellyfin/jellyfin:latest

COPY start_jellyfin.sh .
RUN chmod +x start_jellyfin.sh

COPY test_media/ /test_media/

RUN mkdir /jellyfin_config

# override the config dir such that we can commit the data files into the image
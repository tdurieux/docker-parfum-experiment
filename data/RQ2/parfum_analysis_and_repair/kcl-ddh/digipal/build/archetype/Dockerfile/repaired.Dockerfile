# To build Archetype docker image:
#
# DROP A ARCHETYPE.TAR.GZ IN THIS FOLDER
#
# docker build -t gnoelddh/archetype archetype --no-cache
#
# Then run the container like this:
#
# docker run -ti -p 8080:80 gnoelddh/archetype
#

FROM kingsdigitallab/archetype:latest

ENV SHELL /bin/bash
ENV DP_WS_PORT 80
EXPOSE 80
WORKDIR /home/digipal

# The site will be built from this backup
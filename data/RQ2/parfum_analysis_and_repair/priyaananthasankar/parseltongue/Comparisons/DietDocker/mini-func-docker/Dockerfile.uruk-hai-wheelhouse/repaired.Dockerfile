FROM prananth/uruk-hai:v1
RUN apk add --no-cache freetype-dev libpng-dev openblas-dev && \
    pip3 install --no-cache-dir numpy scipy

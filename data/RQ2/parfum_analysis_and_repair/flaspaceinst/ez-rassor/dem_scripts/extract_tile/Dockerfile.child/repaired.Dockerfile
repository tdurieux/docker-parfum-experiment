FROM mybase

RUN apt-get update && apt-get install --no-install-recommends -y \
    software-properties-common \
    python3 && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y ppa:ubuntugis/ppa

RUN apt-get update && apt-get install --no-install-recommends -y \
    gdal-bin \
    python-gdal \
    python3-gdal && rm -rf /var/lib/apt/lists/*;

ADD /extract_tile/queued_dems /tmp/queued_dems
ADD /extract_tile/results /tmp/results
COPY /extract_tile/tile.py /tmp/
COPY /extract_tile/tile_script.sh /tmp/

CMD ["sh", "./tmp/tile_script.sh"]

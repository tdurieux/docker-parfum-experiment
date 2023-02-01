FROM mybase

RUN apt-get update && apt-get install --no-install-recommends -y \
    software-properties-common \
    python3 && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y ppa:ubuntugis/ppa

RUN apt-get update && apt-get install --no-install-recommends -y \
    gdal-bin \
    python-gdal \
    python3-gdal && rm -rf /var/lib/apt/lists/*;

ADD /convert2tif/queued_dems /tmp/queued_dems
ADD /convert2tif/results /tmp/results
COPY /convert2tif/script_convert.sh /tmp/

CMD ["sh", "./tmp/script_convert.sh"]

FROM mybase

RUN apt-get update && apt-get install --no-install-recommends -y \
    software-properties-common \
    python3 && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y ppa:ubuntugis/ppa

RUN apt-get update && apt-get install --no-install-recommends -y \
    gdal-bin \
    python-gdal \
    python3-gdal && rm -rf /var/lib/apt/lists/*;

ADD /mk_gaz_wrld/queued_dems /tmp/queued_dems
ADD /mk_gaz_wrld/downsized_dems /tmp/downsized_dems
ADD /mk_gaz_wrld/converted_dems /tmp/converted_dems
COPY /mk_gaz_wrld/script_convert.sh /tmp/
COPY /mk_gaz_wrld/check_dem_size.py /tmp/

CMD ["sh", "./tmp/script_convert.sh"]

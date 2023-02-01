FROM mybase

RUN apt-get update && apt-get install --no-install-recommends -y \
    software-properties-common \
    python3 \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir scipy

RUN add-apt-repository -y ppa:ubuntugis/ppa

RUN apt-get update && apt-get install --no-install-recommends -y \
    gdal-bin \
    python-gdal \
    python3-gdal && rm -rf /var/lib/apt/lists/*;

ADD /get_elev/queued_dems /tmp/queued_dems
ADD /get_elev/dem_results /tmp/dem_results
COPY /get_elev/get_coords.py /tmp/
COPY /get_elev/readDEM.py /tmp/
COPY /get_elev/sample_all_dems.sh /tmp/

CMD ["sh", "./tmp/sample_all_dems.sh"]

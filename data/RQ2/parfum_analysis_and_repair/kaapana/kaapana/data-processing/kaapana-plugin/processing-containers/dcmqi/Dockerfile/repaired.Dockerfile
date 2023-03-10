FROM local-only/base-python-cpu:0.1.0

LABEL IMAGE="dcmqi"
LABEL VERSION="v1.2.4"
LABEL CI_IGNORE="False"

# set work directory
WORKDIR /kaapanasrc

COPY files/requirements.txt ./
RUN pip3 install --no-cache-dir -r ./requirements.txt

#Release 1.2.4
RUN mkdir -p /app/src && wget --no-check-certificate https://github.com/QIICR/dcmqi/releases/download/v1.2.4/dcmqi-1.2.4-linux.tar.gz -O /app/src/dcmqi.tar.gz \
    && mkdir -p /app/dcmqi && tar -xzf /app/src/dcmqi.tar.gz --strip 1 -C /app/dcmqi && rm -rf /app/src/dcmqi.tar.gz

#RUN cat /etc/os-release
RUN apt-get update && apt-get -y --no-install-recommends install vim \
    && rm -rf /var/lib/apt/lists/*

#COPY files/create_segmentation_json.py .
COPY files/code_lookup_table.json /kaapanasrc/
COPY files/tid1500_template.json /kaapanasrc/
COPY files/itkimage2segimage.py /kaapanasrc/
COPY files/segimage2itkimage.py /kaapanasrc/
COPY files/tid1500writer.py /kaapanasrc/
COPY files/convert.sh /kaapanasrc/
RUN chmod +x /kaapanasrc/convert.sh

ENTRYPOINT ["/bin/bash", "/kaapanasrc/convert.sh"]
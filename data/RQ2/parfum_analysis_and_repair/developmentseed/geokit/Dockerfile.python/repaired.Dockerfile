FROM lambgeo/lambda-gdal:3.2-python3.8

LABEL maintainer "developmentseed"

ENV PYTHONIOENCODING="UTF-8" 
ENV PATH=/script:$PATH
ENV PYTHONPATH  "${PYTHONPATH}:/script"

RUN yum install -y cmake build-essential libjpeg-devel libpng-devel && rm -rf /var/cache/yum


COPY /python-scripts /script
WORKDIR /script

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir .

VOLUME /mnt/data
WORKDIR /mnt/data

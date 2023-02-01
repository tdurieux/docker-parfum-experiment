FROM tiangolo/meinheld-gunicorn-flask

MAINTAINER JRC UNIT D5

COPY ./requirements.txt /app/
WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y python-numpy gdal-bin libgdal-dev gcc nano && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal
RUN export C_INCLUDE_PATH=/usr/include/gdal

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --user -r requirements.txt

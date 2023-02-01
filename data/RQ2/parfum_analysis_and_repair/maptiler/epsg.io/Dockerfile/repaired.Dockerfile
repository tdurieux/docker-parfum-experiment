FROM klokantech/gdal:1.11

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update \
&& apt-get -qq -y --no-install-recommends install curl \
&& curl -f https://bootstrap.pypa.io/get-pip.py | python \
&& mkdir -p /var/www && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -q -r /tmp/requirements.txt

COPY . /var/www/epsg.io
VOLUME /var/www/epsg.io
WORKDIR /var/www/epsg.io

EXPOSE 8000
ENV FLASK_APP=/var/www/epsg.io/app.py

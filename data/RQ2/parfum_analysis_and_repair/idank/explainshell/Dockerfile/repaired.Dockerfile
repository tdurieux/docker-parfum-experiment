FROM python:2.7

MAINTAINER Simon Toivo Telhaug <simon.toivo@gmail.com>

RUN apt-get update \
&& apt-get install --no-install-recommends man-db -y && rm -rf /var/lib/apt/lists/*;

ADD ./requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir --upgrade pip \
&& python --version \
&& pip install --no-cache-dir -r /tmp/requirements.txt

ADD ./ /opt/webapp/
WORKDIR /opt/webapp
EXPOSE 5000

CMD ["make", "serve"]

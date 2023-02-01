FROM python:3.5
MAINTAINER HJK <HJKdev@gmail.com>
RUN mkdir /lambda
WORKDIR /lambda
ADD . /lambda/
RUN apt-get install -y --no-install-recommends libxml2-dev libxslt-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt

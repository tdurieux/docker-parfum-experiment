####################################
#
#  Dockerfile for Root the Box
#  v0.1.3 - By Moloch, ElJeffe

FROM python:3.8

RUN mkdir /opt/rtb
ADD . /opt/rtb

RUN apt-get update && apt-get install --no-install-recommends -y \
build-essential zlib1g-dev rustc \
python3-pycurl sqlite3 libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

ADD ./setup/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt --upgrade

ENV SQL_DIALECT=sqlite

VOLUME ["/opt/rtb/files"]
ENTRYPOINT ["python3", "/opt/rtb/rootthebox.py", "--setup=docker"]

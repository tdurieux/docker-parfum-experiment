FROM python:3.9

ENV PYTHONUNBUFFERED 1

RUN mkdir /opt/rowboat

COPY requirements.txt /opt/rowboat/
RUN pip install --no-cache-dir -r /opt/rowboat/requirements.txt

COPY [^.]* /opt/rowboat/
WORKDIR /opt/rowboat
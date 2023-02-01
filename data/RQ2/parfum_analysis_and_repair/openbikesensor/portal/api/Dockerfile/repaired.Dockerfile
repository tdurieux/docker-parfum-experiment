FROM python:3.9.7-bullseye

WORKDIR /opt/obs/api

ADD scripts /opt/obs/scripts
RUN pip install --no-cache-dir -e /opt/obs/scripts

ADD requirements.txt /opt/obs/api/
RUN pip install --no-cache-dir -r requirements.txt
ADD setup.py /opt/obs/api/
ADD obs /opt/obs/api/obs/
RUN pip install --no-cache-dir -e .

EXPOSE 8000

CMD ["openbikesensor-api"]

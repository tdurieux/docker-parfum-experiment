FROM python:3.7-alpine
WORKDIR /app
RUN apk add --no-cache git
RUN git clone -b main https://github.com/RiffSphere/Collectarr /app
RUN pip install --no-cache-dir -r requirements.txt
CMD sh /app/folders.sh && python /app/collectarr.py /config

VOLUME /config


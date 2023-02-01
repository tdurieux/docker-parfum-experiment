FROM petkr/gdal-python-alpine
RUN apk update
RUN apk add --no-cache git
RUN apk add --no-cache g++
RUN git clone https://github.com/vascobnunes/fetchLandsatSentinelFromGoogleCloud
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir fels
ENTRYPOINT ["fels"]
CMD []
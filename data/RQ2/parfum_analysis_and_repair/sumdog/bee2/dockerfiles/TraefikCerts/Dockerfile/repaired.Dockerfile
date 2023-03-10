FROM python:3.8

ENV TARGET_CONTAINER xmpp

RUN pip3 install --no-cache-dir watchdog

COPY extractor /
RUN chmod 755 /extractor

CMD ["python","-u","/extractor"]
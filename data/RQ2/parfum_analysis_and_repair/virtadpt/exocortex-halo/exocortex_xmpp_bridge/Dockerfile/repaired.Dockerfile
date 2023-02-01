FROM alpine:latest
LABEL application="Exocortex XMPP Bridge"
RUN apk update && \
    apk add --no-cache python2 && \
    apk add --no-cache py2-pip
ADD . /app/
RUN pip install --no-cache-dir -r /app/requirements.txt
EXPOSE 8003
WORKDIR /app
USER nobody
CMD ["python", "exocortex_xmpp_bridge.py"]

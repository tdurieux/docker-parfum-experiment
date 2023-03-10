FROM envoyproxy/envoy-alpine

RUN apk update
RUN apk add --no-cache python3
RUN apk add --no-cache inotify-tools
RUN mkdir /src

ADD entrypoint.sh /src
ADD certwatch.sh /src
ADD hot-restarter.py /src
ADD start-envoy.sh /src
ADD server.yaml /src

# Flask app
ADD server.py /src
ADD requirements.txt /src
RUN pip3 install --no-cache-dir -r /src/requirements.txt

# app, certificate watcher and envoy
ENTRYPOINT ["/src/entrypoint.sh"]
CMD ["python3", "/src/hot-restarter.py", "/src/start-envoy.sh"]

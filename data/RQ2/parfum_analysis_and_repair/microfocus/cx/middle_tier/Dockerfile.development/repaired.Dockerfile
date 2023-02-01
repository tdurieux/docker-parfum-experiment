FROM ubuntu:16.04
WORKDIR /opt/middle_tier

RUN apt-get update && apt-get install --no-install-recommends -qy \
    build-essential python3-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -qy virtualenv && rm -rf /var/lib/apt/lists/*;
RUN virtualenv -p /usr/bin/python3.5 /opt/penv

COPY requirements.txt /opt/middle_tier
RUN . /opt/penv/bin/activate && pip3 install --no-cache-dir -r requirements.txt

EXPOSE 80
ENTRYPOINT ["/opt/penv/bin/python"]
CMD ["app.py"]

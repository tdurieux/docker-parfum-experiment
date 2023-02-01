FROM aostanin/debian

RUN apt-get install --no-install-recommends -qy mysql-client python3 && rm -rf /var/lib/apt/lists/*;

ADD start.py /start.py

ENTRYPOINT ["/start.py"]

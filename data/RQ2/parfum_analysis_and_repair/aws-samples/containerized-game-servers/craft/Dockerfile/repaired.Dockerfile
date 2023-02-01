FROM arm64v8/python:2
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y sqlite3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim net-tools telnet && rm -rf /var/lib/apt/lists/*;
RUN /usr/local/bin/python -m pip install --upgrade pip
ADD deps /deps
ADD src /src
ADD server.py /server.py
ADD world.py /world.py
RUN gcc -std=c99 -O3 -fPIC -shared -o world -I src -I deps/noise deps/noise/noise.c src/world.c
RUN pip install --no-cache-dir requests boto3 psycopg2
RUN pip install --no-cache-dir awscli

CMD ["python","/server.py"]

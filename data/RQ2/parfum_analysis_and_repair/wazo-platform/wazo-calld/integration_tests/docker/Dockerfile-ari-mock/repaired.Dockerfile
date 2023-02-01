FROM p0bailey/docker-flask

RUN apt-get update -q && apt-get install --no-install-recommends -yq gunicorn && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir flask-sockets

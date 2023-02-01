FROM python

RUN apt-get update && apt-get install --no-install-recommends -y libgcrypt20-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pygcrypt lxml

WORKDIR /cwd

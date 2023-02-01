FROM andreyfedoseev/django-static-precompiler:18.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    python3.6-dev \
    python3.8-dev \
    python3-pip \
    sqlite3 && rm -rf /var/lib/apt/lists/*;
RUN mkdir /app
WORKDIR /app
ADD requirements-*.txt /app/
RUN pip3 install --no-cache-dir -r requirements-dev.txt
ADD . /app/
RUN pip3 install --no-cache-dir -e .[libsass]

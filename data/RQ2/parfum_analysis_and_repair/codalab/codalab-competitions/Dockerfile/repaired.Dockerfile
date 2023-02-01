FROM python:3.8.3

# For nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y npm netcat nodejs python-dev libmemcached-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip# make things faster, hopefully

COPY codalab/requirements/common.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app/codalab

FROM nikolaik/python-nodejs:python3.8-nodejs16

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libpq-dev \
        curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /app

RUN npm install -g npm && npm cache clean --force;
RUN cd client && npm ci --also=dev && cd ..

ENV LANG=C.UTF-8

CMD python daemon.py

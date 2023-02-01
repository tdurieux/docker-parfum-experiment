FROM python:3.9

RUN apt-get -yq update \
        && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
            build-essential \
            qpdf \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /vacina-manaus-backend

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

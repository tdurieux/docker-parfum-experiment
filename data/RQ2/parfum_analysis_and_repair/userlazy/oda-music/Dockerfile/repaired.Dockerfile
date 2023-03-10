FROM rxymx/odamusic:newest

RUN apt-get update -y && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY . /app/
WORKDIR /app/
RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir -U -r requirements.txt
CMD python3 -m oda

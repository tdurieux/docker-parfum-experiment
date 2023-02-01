FROM kennethjiang/octopi-1.7.3:python3

RUN apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir ipdb

COPY . /app

WORKDIR /app

RUN pip3 install --no-cache-dir -e ./


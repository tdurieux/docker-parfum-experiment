FROM kennethjiang/octopi-1.7.3:python2

RUN apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir ipdb

COPY . /app

WORKDIR /app

RUN pip install --no-cache-dir -e ./


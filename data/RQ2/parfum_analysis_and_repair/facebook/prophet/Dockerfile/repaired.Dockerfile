FROM python:3.7-stretch

RUN apt-get -y --no-install-recommends install libc-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pip==19.1.1

COPY python/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir ipython==7.5.0

COPY . .

WORKDIR python

RUN python setup.py install

WORKDIR /


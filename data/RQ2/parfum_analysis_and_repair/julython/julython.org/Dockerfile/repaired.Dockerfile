FROM python:2.7.11-wheezy

COPY requirements.txt ./requirements.txt
COPY requirements-dev.txt ./requirements-dev.txt

RUN apt-get install --no-install-recommends -y libmysqlclient-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /usr/local/julython.org

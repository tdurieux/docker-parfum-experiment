FROM docker.com/libresbc
RUN rm -rf /usr/libresbc
ADD . /libresbc
RUN apt-get update -y && apt-get install --no-install-recommends -y build-essential libmysqlclient-dev python-pip python-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
FROM Debian:latest
FROM python:3.7.4

RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
ADD . /usr/src/app

RUN apt-get install --no-install-recommends -y python3-distutils && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt


COPY . .

RUN sh -ac 'cd /usr/src/app && python3 start_polling.py'


RUN echo "run"

FROM python:3.7.4
MAINTAINER Max Bridgland <mabridgland@protonmail.com>

RUN mkdir -p /usr/src/slacky && rm -rf /usr/src/slacky
WORKDIR /usr/src/app

ADD requirements.txt /usr/src/app/requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get install --no-install-recommends libopencv-dev python3-opencv -y && rm -rf /var/lib/apt/lists/*;

ADD . /usr/src/app

CMD python -m slacky
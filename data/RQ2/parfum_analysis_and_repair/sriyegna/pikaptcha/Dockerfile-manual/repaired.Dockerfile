FROM phusion/baseimage:latest
MAINTAINER newjanson

WORKDIR /usr/src/app

RUN apt-get update && apt-get install --no-install-recommends -y chromium-chromedriver python python-pip git build-essential libssl-dev libffi-dev python-dev tar wget x11vnc xvfb && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
COPY . /usr/src/app/

RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && tar xvfj phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/bin \
    && rm -rf phantomjs-2.1.1-linux-x86_64* && rm phantomjs-2.1.1-linux-x86_64.tar.bz2

RUN for r in `cat requirements.txt`; do \
    pip install --no-cache-dir $r; \
done
RUN pip install --no-cache-dir .

RUN mkdir ~/.vnc \
    && x11vnc -storepasswd ENTER_PASSWORD_HERE ~/.vnc/passwd

ENV PATH=$PATH:/usr/lib/chromium-browser/

EXPOSE 5900

ENTRYPOINT ["x11vnc", "-forever", "-usepw", "-create"]

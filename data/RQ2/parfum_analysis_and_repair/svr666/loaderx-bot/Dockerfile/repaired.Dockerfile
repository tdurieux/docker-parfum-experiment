FROM lzzy12/mega-sdk-python:latest

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

RUN apt-get -qq update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    apt-add-repository non-free && \
    apt-get -qq update && \
    apt-get -qq --no-install-recommends install -y p7zip-full p7zip-rar aria2 curl pv jq ffmpeg locales python3-lxml && \
    apt-get purge -y software-properties-common && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt .
COPY extract /usr/local/bin
RUN chmod +x /usr/local/bin/extract
RUN pip3 install --no-cache-dir -r requirements.txt && \
    apt-get -qq purge git

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
COPY . .
COPY netrc /root/.netrc
RUN chmod +x aria.sh

CMD ["bash","start.sh"]

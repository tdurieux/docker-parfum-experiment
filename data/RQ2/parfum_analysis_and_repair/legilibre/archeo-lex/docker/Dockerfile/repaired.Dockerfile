FROM debian:jessie

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y libarchive13 python-pip git htop sqlite3 && \
    apt-get install --no-install-recommends -y python2.7-dev libxml2-dev libxslt1-dev python-setuptools python-wheel && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /root/legilibre && \
    cd /root/legilibre && \
    mkdir -p code tarballs sqlite textes cache && \
    cd code && \
    git clone https://github.com/Legilibre/legi.py.git && \
    git clone https://github.com/Legilibre/Archeo-Lex.git && \
    cd legi.py && \
    pip install --no-cache-dir -r requirements.txt && \
    cd ../Archeo-Lex && \
    pip install --no-cache-dir -r requirements.txt

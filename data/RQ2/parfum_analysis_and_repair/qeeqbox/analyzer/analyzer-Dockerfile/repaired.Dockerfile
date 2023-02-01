FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip curl libfuzzy-dev yara libmagic-dev libjansson-dev libssl-dev libffi-dev tesseract-ocr libtesseract-dev libssl-dev swig p7zip-full radare2 dmg2img snort && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pyelftools macholib python-magic nltk Pillow jinja2 ssdeep pefile scapy r2pipe pytesseract M2Crypto requests tld tldextract bs4 psutil pymongo==3.12.1 pyOpenSSL oletools extract_msg elasticsearch redis gevent
RUN python3 -m nltk.downloader words punkt wordnet
RUN python3 -c 'import tldextract; tldextract.TLDExtract()'
RUN ln -s /usr/local/lib/python3.7/site-packages/usr/local/lib/libyara.so /usr/local/lib/libyara.so
RUN pip3 install --no-cache-dir --global-option="build" --global-option="--enable-cuckoo" --global-option="--enable-magic" yara-python --global-option="--enable-cuckoo" --global-option="--enable-magic" yara-python --global-option="--enable-magic" yara-python
RUN chmod a+r /etc/snort/snort.conf
RUN wget -O /tmp/community-rules.tar.gz https://www.snort.org/downloads/community/community-rules.tar.gz && \
    mkdir -p /etc/snort/rules && \
    tar zxvf /tmp/community-rules.tar.gz -C /etc/snort/rules --strip-components=1 && rm /tmp/community-rules.tar.gz
ADD ./ /analyzer
RUN mv /analyzer/old-backup-yara-rules-github.zip /tmp/yara-rules.zip && \
	mkdir -p /analyzer/yara/yara-rules-github && \
	7z x /tmp/yara-rules.zip -o/analyzer/yara/ && \
	rm /analyzer/yara/rules-master/index.yar && \
	rm /analyzer/yara/rules-master/index_w_mobile.yar

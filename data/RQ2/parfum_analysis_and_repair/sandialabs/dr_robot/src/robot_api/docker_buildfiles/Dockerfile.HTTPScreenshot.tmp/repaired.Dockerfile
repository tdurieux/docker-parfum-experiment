FROM ubuntu:latest

ENV http_proxy $proxy
ENV https_proxy $proxy

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
    apt-get update \
    && apt-get install --no-install-recommends -y wget git python-dev python-pip libfontconfig unzip firefox ca-certificates && rm -rf /var/lib/apt/lists/*;


ADD certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb || true \
    && apt-get -y -f install

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
    git clone https://github.com/CrimsonK1ng/httpscreenshot.git

RUN cd httpscreenshot \
    && ./install-dependencies.sh \
    && chmod +x httpscreenshot.py \
    && ln -s /httpscreenshot/httpscreenshot.py /usr/bin/httpscreenshot \
    && wget https://chromedriver.storage.googleapis.com/2.44/chromedriver_linux64.zip \
    && unzip -o chromedriver_linux64.zip \
    && ln -s /httpscreenshot/chromedriver /usr/bin/chromedriver

ENTRYPOINT mkdir -p $output/httpscreenshot && cd $output/httpscreenshot && httpscreenshot -i $infile -b chrome -p -w 40  -a -vH

FROM truthhun/dochub:env

WORKDIR /www/dochub

RUN wget https://github.com/TruthHun/DocHub/releases/download/v2.0/DocHub.V2.0_linux_amd64.zip \
    && apt install --no-install-recommends unzip -y \
    && unzip DocHub.V2.0_linux_amd64.zip -d /www/dochub/ \
    && rm -rf /www/dochub/__MACOSX \
    && chmod 0777 -R /www/dochub && rm -rf /var/lib/apt/lists/*;

CMD [ "./DocHub" ]
FROM mwendler/wget
WORKDIR /output

ENV url https://algo.infoprepa.epita.fr

ENTRYPOINT wget -nc --no-check-certificate -r -np -R "index.html/*" ${url}

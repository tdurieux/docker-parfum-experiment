FROM node:10.12.0-alpine

WORKDIR /app

ADD package.json package-lock.json /app/
RUN npm install && npm cache clean --force;
ADD app.js index.js /app/

RUN apk add --no-cache curl && \
    mkdir -p \
        /app/geonames_dump/admin1_codes \
        /app/geonames_dump/admin2_codes \
        /app/geonames_dump/all_countries \
        /app/geonames_dump/alternate_names \
        /app/geonames_dump/cities && \
    cd /app/geonames_dump && \
    curl -f -L -o admin1_codes/admin1CodesASCII.txt https://download.geonames.org/export/dump/admin1CodesASCII.txt && \
    curl -f -L -o admin2_codes/admin2Codes.txt https://download.geonames.org/export/dump/admin2Codes.txt && \
    curl -f -L -o all_countries/allCountries.zip https://download.geonames.org/export/dump/allCountries.zip && \
    curl -f -L -o alternate_names/alternateNames.zip https://download.geonames.org/export/dump/alternateNames.zip && \
    curl -f -L -o cities/cities1000.zip https://download.geonames.org/export/dump/cities1000.zip && \
    cd all_countries && unzip allCountries.zip && rm allCountries.zip && cd .. && \
    cd cities && unzip cities1000.zip && rm cities1000.zip && cd .. && \
    cd alternate_names && unzip alternateNames.zip && rm alternateNames.zip

ENTRYPOINT ["npm"]
CMD ["start"]


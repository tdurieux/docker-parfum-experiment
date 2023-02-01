FROM php:7.3.2-cli-stretch

MAINTAINER Youri hideOut <youri@youhide.com.br>

RUN apt update \
&& apt install --no-install-recommends -y unzip libgmp-dev && rm -rf /var/lib/apt/lists/*;
RUN pecl install mongodb \
&& docker-php-ext-install sockets gmp \
&& docker-php-ext-enable mongodb

RUN ggID='1SsMQsIq_EhAbofKECYXkiKzSM0D63YE-' \
&& ggURL='https://drive.google.com/uc?export=download' \
&& filename="$( curl -f -sc /tmp/gcokie "${ggURL}&id=${ggID}" | grep -o '="uc-name.*</span>' | sed 's/.*">//;s/<.a> .*//')" \
&& getcode="$(awk '/_warning_/ {print $NF}' /tmp/gcokie)" \
&& curl -f -Lb /tmp/gcokie "${ggURL}&confirm=${getcode}&id=${ggID}" -o "/tmp/${filename}"

WORKDIR /ultimaphp
COPY . ./
RUN mkdir -p /UOLocation
RUN unzip -o /tmp/Muls.zip -d /UOLocation
RUN rm -rf /tmp/Muls.zip

# RUN DOCKER_IP=$(awk 'END{print $1}' /etc/hosts); sed -i -- "s/ip=127.0.0.1/ip=${DOCKER_IP}/g" ultimaphp.ini
RUN sed -i -- 's/ip=127.0.0.1/ip=0.0.0.0/g' ultimaphp.ini
RUN sed -i -- 's/host=127.0.0.1/host=mongo/g' ultimaphp.ini

CMD [ "php", "startserver.php" ]

EXPOSE 2593

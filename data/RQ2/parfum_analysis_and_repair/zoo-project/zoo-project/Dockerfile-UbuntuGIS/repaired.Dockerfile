# Build with `docker build . -t zoo -f Dockerfile-UbuntuGIS`
# Run with `docker run --name zoo-demo -d -p 80:80 zoo`

FROM ubuntu/apache2:2.4-20.04_edge

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common git wget vim \
    && rm -rf /var/lib/apt/lists/* \
    && add-apt-repository ppa:ubuntugis/ubuntugis-unstable \
    && apt-get update \
    && apt-get install --no-install-recommends -y zoo-kernel zoo-service-ogr \
    zoo-service-status zoo-service-otb zoo-service-openapi zoo-api websocketd && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/ZOO-Project/examples.git zoo-demo \
    && mv zoo-demo /var/www/html/zoo-demo \
    && chmod -R 755 /var/www/html/zoo-demo \
    && rm -rf zoo-demo

RUN git clone https://github.com/swagger-api/swagger-ui.git \
    && mv swagger-ui/dist /var/www/html/swagger-ui \
    && chmod -R 755 /var/www/html/swagger-ui \
    && sed "s=https://petstore.swagger.io/v2/swagger.json=http://localhost/zoo-demo/ogc-api/api=g" -i /var/www/html/swagger-ui/index.html \
    && rm -rf swagger-ui

COPY docker/ubuntugis/main.cfg /etc/zoo-project/main.cfg
COPY docker/ubuntugis/oas.cfg /etc/zoo-project/oas.cfg
COPY docker/ubuntugis/.htaccess /var/www/html/zoo-demo/.htaccess
COPY docker/ubuntugis/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN mkdir -p /var/data \
    && cp /var/lib/zoo-project/updateStatus.xsl /var/data/ \
    && ln -s /tmp /var/www/html/mpPathRelativeToServerAdress \
    && chown -R www-data:www-data /var/data \
    && ln -s /usr/share/zoo-project/openapi/server/publish.py /usr/lib/cgi-bin/publish.py \
    && ln -s /usr/share/zoo-project/openapi/server/subscriber.py /usr/lib/cgi-bin/subscriber.py \
    && ln -s /usr/share/zoo-project/openapi/static /var/www/html/zoo-demo/static \
    && sed -i "s|serviceProvider = service|serviceProvider = openapi|g" /etc/zoo-project/display.zcfg \
    && a2enmod cgi rewrite

RUN cp /etc/zoo-project/main.cfg /usr/lib/cgi-bin/ \
    && cp /etc/zoo-project/oas.cfg /usr/lib/cgi-bin/
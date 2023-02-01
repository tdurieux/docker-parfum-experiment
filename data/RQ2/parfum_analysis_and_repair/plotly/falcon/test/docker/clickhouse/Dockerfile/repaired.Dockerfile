FROM yandex/clickhouse-server:18.14

ADD https://raw.githubusercontent.com/plotly/datasets/master/2010_alcohol_consumption_by_country.csv /2010_alcohol_consumption_by_country.csv

RUN sed -i -e "1d" /2010_alcohol_consumption_by_country.csv

RUN chmod 777 /2010_alcohol_consumption_by_country.csv

RUN apt-get -y update && apt-get -y --no-install-recommends install curl clickhouse-client && rm -rf /var/lib/apt/lists/*;

COPY setup.sh /

RUN chmod +x /setup.sh

EXPOSE 9000 8123

CMD /setup.sh
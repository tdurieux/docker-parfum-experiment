FROM ubuntu
RUN apt-get update && apt-get -y --no-install-recommends install apt-transport-https curl net-tools && rm -rf /var/lib/apt/lists/*;
RUN echo "deb https://packagecloud.io/grafana/testing/debian/ jessie main" > /etc/apt/sources.list.d/grafana.list
RUN curl -f https://packagecloud.io/gpg.key | apt-key add -
RUN apt-get update
RUN apt-get -y --no-install-recommends install libfontconfig1 libfreetype6 wget grafana && rm -rf /var/lib/apt/lists/*;

COPY grafana.ini /etc/grafana/grafana.ini

RUN grafana-cli plugins install raintank-worldping-app

# add script, but don't run it yet. will be run when grafana is running
ADD create-dev-datasource.sh /tmp/create-dev-datasource.sh
RUN chmod +x /tmp/create-dev-datasource.sh

ADD dashboards /tmp/dashboards

expose 3000

WORKDIR /usr/share/grafana
ENTRYPOINT ["/usr/sbin/grafana-server"]
CMD ["--config", "/etc/grafana/grafana.ini"]

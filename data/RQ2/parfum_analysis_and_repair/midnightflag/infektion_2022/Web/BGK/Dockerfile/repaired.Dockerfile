FROM golang:1.18
RUN useradd enituop
RUN apt-get update
RUN apt-get install --no-install-recommends -y git && apt-get install --no-install-recommends -y python3 && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*;
RUN apt install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;
RUN go install -v github.com/projectdiscovery/notify/cmd/notify@latest
RUN mv /go/bin/notify /usr/bin/
COPY ./flag.txt /root/
RUN chmod 600 /root/flag.txt
RUN apt-get -y --no-install-recommends install cron && rm -rf /var/lib/apt/lists/*;
COPY job-cron /etc/cron.d/job-cron
RUN chmod 0640 /etc/cron.d/job-cron
RUN crontab /etc/cron.d/job-cron
COPY start.sh /start.sh
RUN chmod +x /start.sh
COPY ./provider-config.yaml /root/.config/notify/
RUN chmod 755 /root ; chmod 777 /root/.config ; chmod 777 /root/.config/notify; chmod 777 /root/.config/notify/provider-config.yaml
EXPOSE 8181
WORKDIR /home/enituop
COPY ./BGK/ /home/enituop/web
RUN chown -R enituop:enituop /home/enituop/web/
RUN pip3 install --no-cache-dir -r /home/enituop/web/requirements.txt
RUN pip3 install --no-cache-dir lxml
ENV FLASK_APP=web
USER root
CMD ["bash","/start.sh"]

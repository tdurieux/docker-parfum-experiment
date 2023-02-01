FROM nginx
RUN rm /etc/nginx/conf.d/default.conf
WORKDIR /opt/harness/proxy
COPY run.sh /opt/harness/proxy
COPY scripts /opt/harness/proxy/scripts
COPY pov_scripts /opt/harness/proxy/pov_scripts

RUN chmod +x /opt/harness/proxy/scripts/*.sh
RUN chmod +x /opt/harness/proxy/pov_scripts/*.sh
RUN chmod +x /opt/harness/proxy/run.sh
CMD ./run.sh
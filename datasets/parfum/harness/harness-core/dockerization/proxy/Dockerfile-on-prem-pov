FROM nginx
RUN rm /etc/nginx/conf.d/default.conf
COPY harness-on-prem-pov-proxy.conf /etc/nginx/conf.d/

WORKDIR /opt/harness/proxy

COPY pov_scripts/run.sh pov_scripts/replace_parameters.sh /opt/harness/proxy/

RUN chmod +x *.sh

CMD ./run.sh
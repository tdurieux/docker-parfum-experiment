FROM {{ registry_host }}:{{ registry_port }}/owasp/zap2docker-stable:{{ zap2docker_stable_version }}
MAINTAINER Michael Joseph Walsh <nemonik@gmail.com>

# Drone needs containers that run as root cuz Docker volumes are owned by root by default. 
# A possible workaround: https://stackoverflow.com/questions/50593635/how-to-specify-a-user-for-a-given-build-stage-in-drone

USER root

{% if CA_CERTIFICATES %}
{% for ca in CA_CERTIFICATES if 'ROOT' in ca %}
RUN cd /tmp && \
     wget -O {{ ca.split("/")[3] }} {{ ca }} && \
     keytool -noprompt -storepass changeit -importcert -keystore cacerts -file {{ca.split("/")[3]}}
{% endfor %}

RUN cd /usr/local/share/ca-certificates/ && {% for ca in CA_CERTIFICATES %} wget {{ ca }} &&{% endfor %} update-ca-certificates
{% endif %}

ENV HOME /root

RUN chown root:root -R /zap && \
	chown root:root -R /zap && \
        cp /home/zap/.xinitrc /root/. && \
	chmod a+x /root/.xinitrc
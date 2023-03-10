FROM {{ registry_host }}:{{ registry_port }}/selenium/standalone-firefox:{{ selenium_standalone_firefox_version }} 
MAINTAINER Michael Joseph Walsh <nemonik@gmail.com>

{% if CA_CERTIFICATES%}
RUN cd /usr/local/share/ca-certificates/ &&{% for ca in CA_CERTIFICATES %} sudo wget {{ ca }} &&{% endfor %} sudo update-ca-certificates
{% endif %}
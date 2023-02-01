FROM docker-base-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y build-essential python-dev && rm -rf /var/lib/apt/lists/*; # Dependencies for sonic-cfggen


{% if docker_config_engine_debs.strip() %}
COPY \
{% for deb in docker_config_engine_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/
{%- endif -%}

{% if docker_config_engine_debs.strip() %}
RUN dpkg -i \
{% for deb in docker_config_engine_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor %}
{%- endif -%}

{% if docker_config_engine_whls.strip() %}
COPY \
{% for whl in docker_config_engine_whls.split(' ') -%}
python-wheels/{{ whl }}{{' '}}
{%- endfor -%}
python-wheels/
{%- endif -%}

{% if docker_config_engine_whls.strip() %}
RUN pip install \
{% for whl in docker_config_engine_whls.split(' ') -%}
python-wheels/{{ whl }}{{' '}}
{%- endfor %}
{%- endif -%}

# Copy files
COPY ["files/swss_vars.j2", "/usr/share/sonic/templates/"]

## Clean up
RUN apt-get purge -y build-essential python-dev; apt-get clean -y; apt-get autoclean -y; apt-get autoremove -y
RUN rm -rf /debs /python-wheels

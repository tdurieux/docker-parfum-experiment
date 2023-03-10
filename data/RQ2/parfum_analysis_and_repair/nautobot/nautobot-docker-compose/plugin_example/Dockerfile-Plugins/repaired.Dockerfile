ARG PYTHON_VER
ARG NAUTOBOT_VERSION=1.2.8
FROM networktocode/nautobot:${NAUTOBOT_VERSION}-py${PYTHON_VER}

RUN pip install --no-cache-dir --upgrade pip wheel

COPY ./plugin_requirements.txt /opt/nautobot/
RUN pip install --no-cache-dir --no-warn-script-location -r /opt/nautobot/plugin_requirements.txt

COPY config/nautobot_config.py /opt/nautobot/nautobot_config.py

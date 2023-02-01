ARG PYTHON_VER=3.9
ARG NAUTOBOT_VERSION=1.2.8
FROM networktocode/nautobot:${NAUTOBOT_VERSION}-py${PYTHON_VER} as base

USER 0
RUN apt-get update -y && apt-get install --no-install-recommends -y libldap2-dev libsasl2-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

# ---------------------------------
# Stage: Builder
# ---------------------------------
FROM base as builder

RUN apt-get install --no-install-recommends -y gcc && \
    apt-get autoremove -y && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip wheel && pip3 install --no-cache-dir django-auth-ldap

# ---------------------------------
# Stage: Final
# ---------------------------------
FROM base as final
ARG PYTHON_VER
USER 0

COPY --from=builder /usr/local/lib/python${PYTHON_VER}/site-packages /usr/local/lib/python${PYTHON_VER}/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
USER nautobot

WORKDIR /opt/nautobot

FROM toricls/gnucobol:latest

RUN apt-get update && apt-get install --no-install-recommends -y curl \
    && curl -f -sL https://github.com/openfaas/faas/releases/download/0.13.0/fwatchdog > /usr/bin/fwatchdog \
    && chmod +x /usr/bin/fwatchdog \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root/

COPY handler.cob    .
RUN cobc -x handler.cob
ENV fprocess="./handler"

HEALTHCHECK --interval=1s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]


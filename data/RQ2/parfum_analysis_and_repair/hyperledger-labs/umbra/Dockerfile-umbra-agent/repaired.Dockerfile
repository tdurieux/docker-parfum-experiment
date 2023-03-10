FROM python:3.7.8
RUN apt-get update && apt install --no-install-recommends -y net-tools iproute2 inetutils-ping iperf3 && apt clean && rm -rf /var/lib/apt/lists/*;
COPY . /umbra
WORKDIR /umbra
ENV PYTHONPATH "${PYTHONPATH}:/umbra"

# Set these env for agent at umbra/design/configs.py
ENV AGENT_ADDR "172.17.0.1"
ENV AGENT_PORT "8910"

RUN python setup.py install
CMD ["sh", "-c", "python ./umbra/agent/umbra-agent --uuid agent --address ${AGENT_ADDR}:${AGENT_PORT} --debug"]

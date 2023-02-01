FROM martenseemann/quic-network-simulator-endpoint:latest

RUN apt-get update && apt-get install --no-install-recommends -y wget iperf3 iputils-ping && rm -rf /var/lib/apt/lists/*;

RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && chmod +x wait-for-it.sh

COPY quic/s2n-quic-qns/benchmark/iperf/run.sh .
RUN chmod +x run.sh

ENTRYPOINT [ "./run.sh" ]
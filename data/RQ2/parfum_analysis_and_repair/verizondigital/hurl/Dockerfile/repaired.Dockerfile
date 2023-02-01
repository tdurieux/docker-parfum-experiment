FROM ubuntu:latest
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt update && apt install --no-install-recommends -y libssl-dev git cmake make g++ && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/edgioinc/hurl.git /app
WORKDIR /app
RUN ./build_simple.sh
RUN cd build; make install
ENTRYPOINT ["hurl"]
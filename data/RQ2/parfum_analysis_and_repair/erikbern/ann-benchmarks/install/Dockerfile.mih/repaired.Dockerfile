FROM ann-benchmarks
RUN apt-get update && apt-get install --no-install-recommends -y cmake libhdf5-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/maumueller/mih
RUN cd mih && mkdir bin && cd bin && cmake ../ && make -j4

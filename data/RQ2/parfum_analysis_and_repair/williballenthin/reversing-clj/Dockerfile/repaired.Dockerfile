FROM clojure

RUN apt-get update && apt-get install --no-install-recommends -y make gcc libjna-java && rm -rf /var/lib/apt/lists/*;

# build capstone
RUN git clone https://github.com/aquynh/capstone.git /tmp/capstone
RUN cd /tmp/capstone && ./make.sh && ./make.sh install
# build capstone-java bindings
RUN cd /tmp/capstone/bindings/java && make

# build unicorn
RUN git clone https://github.com/unicorn-engine/unicorn.git /tmp/unicorn
RUN cd /tmp/unicorn && ./make.sh && ./make.sh install
# build unicorn-java bindings
RUN cd /tmp/unicorn/bindings/java && make install && make samples



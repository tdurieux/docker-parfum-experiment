FROM gcc:latest
WORKDIR /usr/src/unbound
RUN apt-get update
# install semantic parser & lexical analyzer
RUN apt-get install --no-install-recommends -y bison flex && rm -rf /var/lib/apt/lists/*;
# install packages used in tests
RUN apt-get install --no-install-recommends -y ldnsutils dnsutils xxd splint doxygen netcat && rm -rf /var/lib/apt/lists/*;
# accept short rsa keys, which are used in tests
RUN sed -i 's/SECLEVEL=2/SECLEVEL=1/g' /usr/lib/ssl/openssl.cnf

CMD ["/bin/bash"]

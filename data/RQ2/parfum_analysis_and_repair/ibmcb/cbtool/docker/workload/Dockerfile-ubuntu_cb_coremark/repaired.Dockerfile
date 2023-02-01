FROM REPLACE_NULLWORKLOAD_UBUNTU

# coremark-install-man
RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN /bin/true; cd /home/REPLACE_USERNAME; git clone https://github.com/eembc/coremark.git
RUN cd /home/REPLACE_USERNAME/coremark/; make
# coremark-install-man

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
FROM REPLACE_NULLWORKLOAD_UBUNTU

# nodejs-install-pm
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
# service_stop_disable nodejs
# nodejs-install-pm

# wrk2-ARCHx86_64-install-man
RUN /bin/true; cd /home/REPLACE_USERNAME/; git clone https://github.com/giltene/wrk2; cd /home/REPLACE_USERNAME/wrk2; make all
# wrk2-ARCHx86_64-install-man

# wrk2-ARCHppc64le-install-man
RUN /bin/true; cd /home/REPLACE_USERNAME/; git clone https://github.com/giltene/wrk2; cd /home/REPLACE_USERNAME/wrk2; make all; /bin/true
# wrk2-ARCHppc64le-install-man

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME

FROM REPLACE_NULLWORKLOAD_UBUNTU

# apache-install-pm
RUN apt-get update && apt-get install --no-install-recommends -y apache2 && rm -rf /var/lib/apt/lists/*;
# service_stop_disable apache2
# apache-install-pm

# wrk-ARCHx86_64-install-man
RUN /bin/true; cd /home/REPLACE_USERNAME/; git clone https://github.com/wg/wrk.git; cd /home/REPLACE_USERNAME/wrk; make all
# wrk-ARCHx86_64-install-man

# wrk-ARCHppc64le-install-man
RUN /bin/true; cd /home/REPLACE_USERNAME/; git clone https://github.com/wg/wrk.git; cd /home/REPLACE_USERNAME/wrk; make all; /bin/true
# wrk-ARCHppc64le-install-man

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME

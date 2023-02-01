FROM REPLACE_NULLWORKLOAD_UBUNTU

# iperf-install-pm
RUN apt-get update && apt-get install --no-install-recommends -y iperf && rm -rf /var/lib/apt/lists/*;
# iperf-install-pm

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
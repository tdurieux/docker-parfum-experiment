FROM REPLACE_NULLWORKLOAD_UBUNTU

# fio-install-pm
RUN apt-get update && apt-get install --no-install-recommends -y libaio1 fio && rm -rf /var/lib/apt/lists/*;
# fio-install-pm

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
FROM REPLACE_NULLWORKLOAD_UBUNTU

# dd-install-pm
RUN apt-get update && apt-get install --no-install-recommends -y coreutils && rm -rf /var/lib/apt/lists/*;
# dd-install-pm

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
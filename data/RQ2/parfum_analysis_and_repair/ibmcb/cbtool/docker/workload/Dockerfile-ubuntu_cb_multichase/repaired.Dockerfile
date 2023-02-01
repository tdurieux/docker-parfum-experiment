FROM REPLACE_NULLWORKLOAD_UBUNTU

# multichase-install-man
RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN cd /home/REPLACE_USERNAME; git clone https://github.com/google/multichase.git; cd /home/REPLACE_USERNAME/multichase; sed -i 's/-Werror//g' Makefile; make
# multichase-install-man

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME

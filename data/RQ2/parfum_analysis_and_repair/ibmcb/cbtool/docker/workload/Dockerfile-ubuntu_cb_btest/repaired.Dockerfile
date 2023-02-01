FROM REPLACE_NULLWORKLOAD_UBUNTU

# btest-install-man
RUN apt-get update && apt-get install --no-install-recommends -y libaio-dev libaio1 && rm -rf /var/lib/apt/lists/*;
RUN wget -N -q -P /home/REPLACE_USERNAME https://sourceforge.net/projects/btest/files/Version-161/Src/btest-161.tar.gz/download
RUN cd /home/REPLACE_USERNAME/; tar -xzf /home/REPLACE_USERNAME/download; cd /home/REPLACE_USERNAME/btest-161/; make
RUN cp -f /home/REPLACE_USERNAME/btest-161/btest /usr/local/bin/btest; chmod 755 /usr/local/bin/btest
RUN cp /usr/local/bin/btest /home/REPLACE_USERNAME/cbtool/3rd_party/btest
# btest-install-man
RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME

FROM REPLACE_NULLWORKLOAD_UBUNTU

# kernbuild-install-pm
RUN apt-get update && apt-get install --no-install-recommends -y build-essential bison flex libelf-dev libssl-dev bc time && rm -rf /var/lib/apt/lists/*;
# kernbuild-install-pm

# kernbench-install-git
RUN mkdir -p /home/REPLACE_USERNAME/foo; chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME; cd /home/REPLACE_USERNAME/foo; sudo git clone https://github.com/linux-test-project/ltp.git -b 20180118
RUN cd /home/REPLACE_USERNAME/foo; sudo chmod +x ltp/utils/benchmark/kernbench-0.42/kernbench
# kernbench-install-git

# kerndata-install-man
RUN mkdir -p /home/REPLACE_USERNAME/foo; cd /home/REPLACE_USERNAME/foo; sudo wget -Nq -P /home/REPLACE_USERNAME/foo https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.16.8.tar.xz; sudo tar xf linux-4.16.8.tar.xz; rm linux-4.16.8.tar.xz sudo mv linux-4.16.8 linux
# kerndata-install-man

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME

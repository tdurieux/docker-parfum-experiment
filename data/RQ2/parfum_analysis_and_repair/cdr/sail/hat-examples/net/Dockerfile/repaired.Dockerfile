FROM codercom/ubuntu-dev

RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y nmap iperf netcat && rm -rf /var/lib/apt/lists/*;

FROM kalilinux/kali-rolling
RUN apt-get update && apt-get upgrade -y && apt-get -y --no-install-recommends install nmap && rm -rf /var/lib/apt/lists/*;
COPY add_nse_function .
RUN cat add_nse_function >> ~/.bashrc
ENTRYPOINT [ "nmap" ]

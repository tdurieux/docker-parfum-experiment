FROM kalilinux/kali-rolling:latest
RUN apt-get update \
&& apt-get install --no-install-recommends -y sqlmap && rm -rf /var/lib/apt/lists/*;

CMD []

FROM kalilinux/kali-rolling:latest

COPY ./subfinder /usr/local/bin/subfinder

ENTRYPOINT [ "subfinder" ]
CMD ["-h"]
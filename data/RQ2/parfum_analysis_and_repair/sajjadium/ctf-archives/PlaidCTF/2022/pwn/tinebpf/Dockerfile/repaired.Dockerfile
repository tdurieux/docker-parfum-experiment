FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y xinetd && rm -rf /var/lib/apt/lists/*;
RUN adduser --no-create-home --disabled-password --gecos "" problem
COPY target/debug/tinebpf /problem
COPY flag.txt /flag.txt
COPY xinetd.conf /etc/xinetd.d/problem
CMD ["/usr/sbin/xinetd", "-dontfork"]

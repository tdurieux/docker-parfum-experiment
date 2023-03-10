FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;

RUN mkdir /pwn/

ADD loglit /pwn/lolglit
ADD flag.txt /pwn/flag.txt

ENV CTF_PORT 8001
EXPOSE 8001
CMD socat TCP-LISTEN:8001,reuseaddr,fork EXEC:"/pwn/lolglit"
FROM amd64/debian

RUN apt-get update && apt-get install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;

RUN mkdir /pwn
RUN useradd --home=/pwn pwnuser

COPY DoubtfulCipher /pwn/DoubtfulCipher
COPY entry.sh /pwn/

RUN chmod 4755 /pwn/DoubtfulCipher
RUN chmod 4755 /pwn/entry.sh

EXPOSE 9001

ENTRYPOINT ["/pwn/entry.sh"]

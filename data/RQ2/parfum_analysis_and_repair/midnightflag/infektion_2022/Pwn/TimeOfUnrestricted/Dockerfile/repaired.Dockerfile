FROM amd64/debian

RUN apt-get update && apt-get install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;

RUN service ssh start

RUN mkdir /pwn
RUN mkdir /adm

RUN useradd -p "$(openssl passwd -1 pwnuser)" --home=/pwn pwnuser
RUN useradd -p "$(openssl passwd -1 admin)" --home=/adm admin

COPY TimeOfUnrestricted /pwn/TimeOfUnrestricted

RUN chown admin /pwn/TimeOfUnrestricted
RUN chmod +s /pwn/TimeOfUnrestricted

COPY flag.txt /flag.txt
RUN chown admin:admin /flag.txt
RUN chmod 400 /flag.txt

EXPOSE 22

ENTRYPOINT service ssh restart && /bin/bash

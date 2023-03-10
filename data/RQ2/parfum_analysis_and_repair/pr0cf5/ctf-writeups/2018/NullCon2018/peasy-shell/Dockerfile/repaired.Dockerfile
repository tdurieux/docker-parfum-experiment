FROM ubuntu:18.04
MAINTAINER unknonwn
LABEL Description="peasyshell" VERSION='1.0'

#installation
RUN apt-get update && apt-get install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;

#user
RUN adduser --disabled-password --gecos '' pwn
RUN chown -R root:pwn /home/pwn/
RUN chmod 750 /home/pwn

RUN touch /home/pwn/flag

RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep
RUN export TERM=xterm

#Copying file
WORKDIR /home/pwn/
COPY gg /home/pwn
COPY flag /home/pwn

#Setting perm.
RUN chown root:pwn /home/pwn/flag
RUN chmod +x /home/pwn/gg
RUN chmod 440 /home/pwn/flag

#Run the program with socat
CMD su pwn -c "socat TCP-LISTEN:4011,reuseaddr,fork EXEC:/home/pwn/gg"

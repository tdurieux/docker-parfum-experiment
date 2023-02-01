FROM ubuntu:latest
ENV user=arbitraryread
RUN apt-get update && apt-get install --no-install-recommends -y xinetd python && rm -rf /var/lib/apt/lists/*;
RUN useradd -m $user
RUN echo "$user     hard    nproc       20" >> /etc/security/limits.conf
COPY ./arbitraryread.py /home/$user/arbitraryread.py
COPY ./flag /flag
COPY ./readservice /etc/xinetd.d/readservice
COPY ./art /home/$user/art
RUN chown -R root:$user /home/$user
RUN chmod -R 750 /home/$user
RUN chown root:$user /flag
RUN chmod 440 /flag
EXPOSE 31337
CMD ["/usr/sbin/xinetd", "-d"]

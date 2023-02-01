FROM ubuntu:latest
ENV user=infoleak
RUN apt-get update && apt-get install --no-install-recommends -y xinetd python && rm -rf /var/lib/apt/lists/*;
RUN useradd -m $user
RUN echo "$user     hard    nproc       20" >> /etc/security/limits.conf
COPY ./infoleak.py /home/$user/infoleak.py
COPY ./flag /home/$user/flag
COPY ./infoleakservice /etc/xinetd.d/infoleakservice
RUN chown -R root:$user /home/$user
RUN chmod -R 750 /home/$user
RUN chown root:$user /home/$user/flag
RUN chmod 440 /home/$user/flag
EXPOSE 31337
CMD ["/usr/sbin/xinetd", "-d"]

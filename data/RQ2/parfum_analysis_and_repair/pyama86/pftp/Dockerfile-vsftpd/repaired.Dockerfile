FROM fauria/vsftpd
ENV FTP_USER="vsuser"
ENV FTP_PASS="vsuser"
ENV PASV_ADDRESS="127.0.0.1"
ENV PASV_MIN_PORT="11100"
ENV PASV_MAX_PORT="11150"
ENV LOCAL_UMASK="022"
VOLUME /home/vsftpd
VOLUME /var/log/vsftpd
RUN echo "log_ftp_protocol=YES" >> /etc/vsftpd/vsftpd.conf
EXPOSE 21

CMD ["/usr/sbin/run-vsftpd.sh"]
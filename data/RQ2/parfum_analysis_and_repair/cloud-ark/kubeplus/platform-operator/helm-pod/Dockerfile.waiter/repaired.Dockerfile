FROM ubuntu:20.04 
COPY kubectl /root/
COPY waiter.sh /root/
RUN chmod +x /root/kubectl && chmod +x /root/waiter.sh
ENTRYPOINT ["/root/waiter.sh"]
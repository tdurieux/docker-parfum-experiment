FROM flitter/init

ADD lagann /usr/local/bin/lagann
ADD init /etc/service/lagann/run

EXPOSE 3000

CMD /sbin/my_init
FROM point-os
VOLUME ["/home/point/www"]
WORKDIR /home/point/www
EXPOSE 8088
CMD ["geweb", "run"]
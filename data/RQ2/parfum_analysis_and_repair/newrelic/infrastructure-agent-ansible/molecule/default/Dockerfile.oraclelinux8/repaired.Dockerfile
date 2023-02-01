FROM oraclelinux:8

# Run a system update so the system doesn't overwrite the fake systemctl later
RUN yum update -y

# Adding fake systemctl and python
RUN curl -f https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py -o /usr/bin/systemctl \
 && yum install python3 -y && rm -rf /var/cache/yum

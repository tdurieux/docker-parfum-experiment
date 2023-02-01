FROM ubuntu:20.04

RUN apt install --no-install-recommends -y composer php-xml php-pdo php-mysqli php-curl openjdk-11-jdk golang curl && rm -rf /var/lib/apt/lists/*;
RUN python3-pip  curl git wget nmap masscan  whatweb  net-tools mobsfscan
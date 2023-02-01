FROM debian:latest
WORKDIR /minik8s
RUN sed -i "s|http://deb.debian.org/debian|http://mirror.sjtu.edu.cn/debian|g" /etc/apt/sources.list && sed -i "s|http://security.debian.org|http://mirror.sjtu.edu.cn|g" /etc/apt/sources.list
RUN apt-get update && apt-get -y --no-install-recommends install nginx && apt-get clean && rm -rf /var/lib/apt/lists/*;
ADD http://minik8s.xyz:8008/ingress-controller-arm ./ingress-controller
RUN chmod +x ingress-controller
CMD ["/bin/bash", "-c", "nginx;./ingress-controller"]

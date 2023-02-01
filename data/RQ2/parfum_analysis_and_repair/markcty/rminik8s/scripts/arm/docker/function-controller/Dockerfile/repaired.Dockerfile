FROM debian:latest
RUN sed -i "s|http://deb.debian.org/debian|http://mirror.sjtu.edu.cn/debian|g" /etc/apt/sources.list && sed -i "s|http://security.debian.org|http://mirror.sjtu.edu.cn|g" /etc/apt/sources.list
RUN apt-get update && apt-get -y --no-install-recommends install zip docker.io && apt-get clean && rm -rf /var/lib/apt/lists/*;
ADD http://minik8s.xyz:8008/function-controller-arm ./function-controller
RUN chmod +x function-controller
COPY ./function_wrapper /templates/function_wrapper
CMD ["./function-controller"]

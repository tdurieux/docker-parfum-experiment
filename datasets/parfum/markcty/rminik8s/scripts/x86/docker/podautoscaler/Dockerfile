FROM debian:latest
WORKDIR /minik8s
ADD http://minik8s.xyz:8008/podautoscaler ./
RUN chmod +x podautoscaler
CMD ["./podautoscaler"]

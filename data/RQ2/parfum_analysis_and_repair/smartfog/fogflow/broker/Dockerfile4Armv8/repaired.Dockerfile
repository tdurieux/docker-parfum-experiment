FROM scratch
ADD broker_arm64  /broker
CMD ["/broker"]
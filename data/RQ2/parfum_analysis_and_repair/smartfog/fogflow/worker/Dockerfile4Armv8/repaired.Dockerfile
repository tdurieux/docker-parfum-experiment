FROM scratch
ADD worker_arm64  /worker
CMD ["/worker"]
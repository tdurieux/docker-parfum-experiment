ARG base_image=registry.nordix.org/cloud-native/meridio/base:1.0.0
FROM ${base_image}
COPY . .
CMD ["/root/start-command"]
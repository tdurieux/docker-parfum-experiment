FROM gcr.io/distroless/base-debian10:debug
COPY contrail-provisioner_linux /app/contrail-provisioner/contrail-provisioner-image.binary
CMD ["/app/contrail-provisioner/contrail-provisioner-image.binary"]
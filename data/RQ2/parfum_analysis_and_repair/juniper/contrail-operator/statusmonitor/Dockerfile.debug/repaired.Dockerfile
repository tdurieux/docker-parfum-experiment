FROM gcr.io/distroless/base-debian10:debug
COPY statusmonitor /app/statusmonitor/contrail-statusmonitor-image.binary
CMD ["/statusmonitor"]
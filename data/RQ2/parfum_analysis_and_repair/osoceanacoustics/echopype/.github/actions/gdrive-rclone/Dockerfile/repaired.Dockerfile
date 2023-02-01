FROM rclone/rclone:latest
RUN apk add --no-cache bash jq
COPY entrypoint.sh /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]

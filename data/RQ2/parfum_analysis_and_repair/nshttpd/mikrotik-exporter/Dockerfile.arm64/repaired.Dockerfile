FROM arm64v8/busybox:1.31.0

EXPOSE 9090

COPY scripts/start.sh /app/
COPY dist/mikrotik-exporter_linux_arm64 /app/mikrotik-exporter

ENTRYPOINT ["/app/start.sh"]
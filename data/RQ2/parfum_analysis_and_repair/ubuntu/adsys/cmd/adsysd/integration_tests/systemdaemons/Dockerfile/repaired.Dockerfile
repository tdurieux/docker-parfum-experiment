FROM ubuntu


ENV DEBIAN_FRONTEND=noninteractive
# we need at least dbusmock 0.25 to use systemd template
RUN \
   apt update && \
   apt install --no-install-recommends -y policykit-1 dbus libglib2.0-bin python3-pip python3-gi python3-dbus && \
   pip install --no-cache-dir python-dbusmock && rm -rf /var/lib/apt/lists/*;

COPY cmd/adsys/integration_tests/systemdaemons/systemdaemons /

ENTRYPOINT ["/systemdaemons"]

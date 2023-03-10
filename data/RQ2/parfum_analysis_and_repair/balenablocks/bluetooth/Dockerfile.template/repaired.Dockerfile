FROM balenalib/%%BALENA_MACHINE_NAME%%-alpine-python:3.8-run
WORKDIR /usr/src

# DBUS is required for bluetooth-agent
ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

# Fix python path for Alpine
ENV PYTHONPATH "${PYTHONPATH}:/usr/lib/python3.8/site-packages"

RUN install_packages bluez bluez-btmgmt py3-dbus py3-gobject3

# For local development
#dev-cmd-live=balena-idle

COPY . .
RUN chmod +x /usr/src/bluetooth-agent

ENTRYPOINT [ "/bin/bash", "/usr/src/entry.sh" ]
CMD [ "/usr/src/bluetooth-agent" ]
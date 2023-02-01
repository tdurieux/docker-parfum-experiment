FROM debian
RUN apt-get update && \
    apt-get install --no-install-recommends -y nsis && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT makensis -V4 -DVERSION=$VERSION -DOUT="/home/dist/grafana-agent-installer.exe" /home/packaging/windows/install_script.nsis
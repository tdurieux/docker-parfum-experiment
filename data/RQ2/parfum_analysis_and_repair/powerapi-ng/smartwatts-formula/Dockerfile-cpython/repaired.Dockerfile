FROM powerapi/powerapi:1.0.7
USER root
RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y libblas-dev liblapack-dev libatlas-base-dev gfortran && rm -rf /var/lib/apt/lists/*;
USER powerapi
COPY --chown=powerapi . /tmp/smartwatts
RUN pip install --user --no-cache-dir "/tmp/smartwatts" && rm -r /tmp/smartwatts

ENTRYPOINT ["python3", "-m", "smartwatts"]

FROM python:slim

WORKDIR /

RUN apt-get update && apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pipx
RUN pipx ensurepath
RUN pipx install git+https://github.com/Tw1sm/spraycharles.git

ENTRYPOINT ["/root/.local/bin/spraycharles"]

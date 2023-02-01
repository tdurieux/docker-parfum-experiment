FROM ubuntu:latest
RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir kubernetes
RUN pip3 install --no-cache-dir PTable
RUN echo "alias kubiscan='python3 /KubiScan/KubiScan.py'" > /root/.bash_aliases
RUN . /root/.bash_aliases
RUN apt-get remove -y python3-pip
COPY . /KubiScan
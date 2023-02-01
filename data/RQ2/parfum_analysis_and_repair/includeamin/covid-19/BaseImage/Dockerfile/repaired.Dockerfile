FROM ubuntu:18.04
EXPOSE 8000
RUN   export LC_ALL=C.UTF-8
RUN   export LANG=C.UTF-8
RUN apt update
RUN apt install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt update && apt install --no-install-recommends -y libsm6 libxext6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsm6 libxrender1 libfontconfig1 && rm -rf /var/lib/apt/lists/*;
WORKDIR app
COPY requirements.txt .requirements.txt

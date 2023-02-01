FROM debian:10.11

RUN apt update -y && apt upgrade -y; apt install --no-install-recommends -y python3 python3-pip python3-venv python3-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /opt/waf-bypass

WORKDIR /opt/waf-bypass

COPY . .

RUN python3 -m pip install -r /opt/waf-bypass/requirements.txt
RUN chmod +x /opt/waf-bypass/main.py

ENTRYPOINT ["/opt/waf-bypass/main.py"]

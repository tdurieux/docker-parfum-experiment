FROM kalilinux/kali-rolling
COPY FudgeC2 /opt/FudgeC2
WORKDIR /opt/FudgeC2
RUN apt update \&& \
 apt install --no-install-recommends python3 python3-pip -y && \
 pip3 install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;
CMD python3 Controller.py

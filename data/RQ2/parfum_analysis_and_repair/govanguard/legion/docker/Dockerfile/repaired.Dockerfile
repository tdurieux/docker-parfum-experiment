FROM gvit/python-secbase:latest
WORKDIR /
ENV DISPLAY :0
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago
RUN git clone https://github.com/GoVanguard/legion.git
RUN cd legion && \
    chmod +x ./startLegion.sh && \
    chmod +x ./deps/* -R && \
    chmod +x ./scripts/* -R && \
    mkdir -p /legion/tmp
RUN cd legion && \
    pip3 install --no-cache-dir -r requirements.txt --upgrade
RUN cd legion && \
    bash ./deps/detectScripts.sh
WORKDIR /legion
CMD ["python3", "legion.py"]

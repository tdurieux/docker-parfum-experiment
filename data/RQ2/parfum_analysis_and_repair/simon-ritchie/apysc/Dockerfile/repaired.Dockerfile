FROM python:3.7.13-buster
ARG WORKDIR="/mnt/apysc/"
RUN mkdir ${WORKDIR}
WORKDIR "${WORKDIR}"
ADD requirements.txt ${WORKDIR}
RUN pip install --no-cache-dir -r requirements.txt
RUN apt update && apt-get install --no-install-recommends -y gstreamer1.0-libav libnss3-tools libatk-bridge2.0-0 libcups2-dev libxkbcommon-x11-0 libxcomposite-dev libxrandr2 libgbm-dev libgtk-3-0 && rm -rf /var/lib/apt/lists/*;
RUN playwright install chromium

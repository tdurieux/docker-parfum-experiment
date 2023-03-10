# Build & run with:
# docker build . -t lucaschess && docker run -it -e "DISPLAY=$DISPLAY" -v "$HOME/.Xauthority:/lucaschess/.Xauthority:ro" -v "$PWD/UserData:/lucaschess/UserData" --network host --rm lucaschess

FROM python:3.9-bullseye
WORKDIR /lucaschess/
ENV HOME=/lucaschess/

RUN apt-get update && \
	apt-get install --no-install-recommends -y portaudio19-dev libqt5gui5 && \
	rm -rf /var/lib/apt/lists/*

ADD requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ADD . .
RUN cd bin/_fastercode && chmod a+x ./linux64.sh && ./linux64.sh
RUN cd bin/_genicons && python ./gentema.py
RUN chmod a+x bin/LucasR.py
WORKDIR /lucaschess/bin/

# To debug problems with Qt, enable the following line:
# ENV QT_DEBUG_PLUGINS=1

CMD ./LucasR.py

FROM balenalib/%%BALENA_MACHINE_NAME%%-debian
WORKDIR /usr/src

ENV PULSE_SERVER=unix:/run/pulse/pulseaudio.socket
# Specify a PULSE_SINK, otherwise use the default
# ENV PULSE_SINK=alsa_output.bcm2835-jack.stereo-fallback

RUN install_packages mplayer
RUN curl -f https://www.kozco.com/tech/LRMonoPhase4.wav --silent --output test.wav

# To play the file: mplayer test.wav
CMD [ "balena-idle" ]

FROM balenalib/%%BALENA_MACHINE_NAME%%-debian
WORKDIR /usr/src

ENV PULSE_SERVER=tcp:audio:4317
# Specify a PULSE_SINK, otherwise use the default
# ENV PULSE_SINK=alsa_output.bcm2835-jack.stereo-fallback

RUN install_packages sox libsox-fmt-pulse
RUN curl -f https://www.kozco.com/tech/LRMonoPhase4.wav --silent --output test.wav

# To play the file: play test.wav
CMD [ "balena-idle" ]

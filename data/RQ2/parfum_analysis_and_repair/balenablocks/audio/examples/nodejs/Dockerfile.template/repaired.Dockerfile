FROM balenalib/%%BALENA_MACHINE_NAME%%-node:12-run

ENV PULSE_SERVER=unix:/run/pulse/pulseaudio.socket
# Specify a PULSE_SINK, otherwise use the default
# ENV PULSE_SINK=alsa_output.bcm2835-jack.stereo-fallback

# Install dependencies for pulseaudio2 node package
RUN install_packages python pkg-config make g++ libpulse-dev
RUN curl -f https://www.kozco.com/tech/LRMonoPhase4.wav --silent --output test.wav

WORKDIR /usr/src
COPY . .

RUN npm install && npm cache clean --force;

# Run: "node play.js" or "node echo.js"
CMD [ "balena-idle" ]

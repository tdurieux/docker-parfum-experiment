FROM logankennelly/arduino-cli-esp8266:latest
USER root

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

USER arduino
RUN arduino-cli core install arduino:avr &&\
    arduino-cli lib install AccelStepper &&\
    arduino-cli lib install "Adafruit NeoPixel"

FROM gpmdp/build-core:latest

RUN sudo apt-get remove --purge libavahi-compat-libdnssd-dev
RUN sudo apt-get autoremove
RUN sudo apt-get update -y && sudo apt-get install -y --no-install-recommends libavahi-compat-libdnssd-dev:i386 && rm -rf /var/lib/apt/lists/*;

CMD ["node"]
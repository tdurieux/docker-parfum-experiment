FROM tinymux:2.12.0.10
COPY game /game/
WORKDIR /game
VOLUME ["/game"]
EXPOSE 2860
ENTRYPOINT ["./Startmux"]
CMD [""]
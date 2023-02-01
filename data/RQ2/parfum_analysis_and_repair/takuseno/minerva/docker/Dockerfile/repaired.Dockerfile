FROM takuseno/d3rlpy:0.90

RUN pip install --no-cache-dir minerva-ui

EXPOSE 9000

CMD ["minerva", "run"]

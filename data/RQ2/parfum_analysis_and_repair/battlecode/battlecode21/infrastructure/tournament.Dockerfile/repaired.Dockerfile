FROM bc21-env

# Install software dependencies
RUN pip3 install --no-cache-dir --upgrade \
    requests

COPY config.py util.py bracketlib.py team_pk team_names maps.json tournament_server.py app/

WORKDIR app
CMD python3 tournament_server.py 0 team_pk team_names maps.json

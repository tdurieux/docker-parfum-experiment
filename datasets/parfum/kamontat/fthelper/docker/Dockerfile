FROM freqtradeorg/freqtrade:develop_plot

# Install postgres compiler support
USER root
RUN apt-get update \
  && apt-get -y install libpq-dev gcc
USER ftuser

# Add Postgres support
RUN pip install --user psycopg2
# Add pandas ta for NostalgiaForInfinity
# https://github.com/iterativv/NostalgiaForInfinity/wiki/Preliminary-Setup#nfi-deployment
RUN pip install --user pandas-ta

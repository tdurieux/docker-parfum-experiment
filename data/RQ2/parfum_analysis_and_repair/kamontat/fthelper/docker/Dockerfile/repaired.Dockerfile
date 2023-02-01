FROM freqtradeorg/freqtrade:develop_plot

# Install postgres compiler support
USER root
RUN apt-get update \
  && apt-get -y --no-install-recommends install libpq-dev gcc && rm -rf /var/lib/apt/lists/*;
USER ftuser

# Add Postgres support
RUN pip install --no-cache-dir --user psycopg2
# Add pandas ta for NostalgiaForInfinity
# https://github.com/iterativv/NostalgiaForInfinity/wiki/Preliminary-Setup#nfi-deployment
RUN pip install --no-cache-dir --user pandas-ta

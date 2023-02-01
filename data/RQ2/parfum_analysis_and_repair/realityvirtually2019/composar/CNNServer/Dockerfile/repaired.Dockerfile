FROM python:3.5.6-slim

# Copy files over
WORKDIR /CNNServer
COPY ./ /CNNServer

ENV PATH=/home/ubuntu/.virtualenvs/bin:$PATH

# Install deps with pip
RUN pip3 install --no-cache-dir tensorflow
RUN pip3 install --no-cache-dir flask
RUN pip3 install --no-cache-dir scipy
RUN pip3 install --no-cache-dir requests
RUN pip3 install --no-cache-dir gevent
RUN pip3 install --no-cache-dir Pillow

# Extenal port to expose
EXPOSE 5000

# Env vars
ENV FLASK_APP server.py
# pls dont steal dis
ENV FORGE_CLIENT_ID p7EoOa2TjOdSJwNTwF1kstzkjaqlKYn2
ENV FORGE_CLIENT_SECRET 6CKbUmJ2x8l93g7q

CMD cd Network/code/MonsterNet && flask run

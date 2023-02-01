FROM python:3.8-slim-buster
LABEL maintainer="nicolo.lucchesi@gmail.com"

# Install the C compiler tools
RUN apt-get update -y && \
  apt-get install --no-install-recommends build-essential -y && \
  apt-get install --no-install-recommends -y wget && \
  apt-get install --no-install-recommends -y python3-opencv && \
  apt-get install --no-install-recommends -y unar && \
  pip install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

# RUN adduser avalanche-user
# RUN chown avalanche-user: /
# USER avalanche-user
# COPY --chown=avalanche-user:avalanche-user . /home/avalanche-user/app
COPY . /app

# WORKDIR /home/avalanche-user/app
WORKDIR /app
RUN python -m venv venv
# Enable venv
ENV PATH="/app/venv/bin:$PATH"

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir .
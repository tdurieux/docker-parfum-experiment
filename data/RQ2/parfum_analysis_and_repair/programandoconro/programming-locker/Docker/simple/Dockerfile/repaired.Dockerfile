FROM debian

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends r-base pip-python git -y && rm -rf /var/lib/apt/lists/*;


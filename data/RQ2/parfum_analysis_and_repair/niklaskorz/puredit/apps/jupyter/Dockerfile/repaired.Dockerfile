FROM node:18

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /build
COPY . .
RUN pip3 install --no-cache-dir -r apps/jupyter/requirements.txt
RUN npm install && npm cache clean --force;
RUN npm -w apps/jupyter run build:prod
RUN pip3 install --no-cache-dir apps/jupyter

RUN useradd --create-home jupyter
WORKDIR /home/jupyter
RUN cp -r /build/apps/jupyter/example .
RUN chown -R jupyter:jupyter /home/jupyter

USER jupyter
EXPOSE 8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser"]

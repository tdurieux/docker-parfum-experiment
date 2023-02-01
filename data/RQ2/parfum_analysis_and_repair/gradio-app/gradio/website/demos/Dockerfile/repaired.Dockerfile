FROM python:3.8

RUN apt-get update && apt-get --assume-yes -y --no-install-recommends install nginx && rm -rf /var/lib/apt/lists/*;
RUN mkdir gradio
RUN pip install --no-cache-dir numpy matplotlib
WORKDIR /gradio
COPY ./gradio ./gradio
COPY ./requirements.txt ./requirements.txt
COPY ./setup.py ./setup.py
COPY ./MANIFEST.in ./MANIFEST.in
COPY ./README.md ./README.md
RUN python setup.py install
WORKDIR /gradio
COPY ./website ./website
COPY ./demo ./demo
COPY ./guides ./guides
COPY ./gradio/components.py ./gradio/components.py
WORKDIR /gradio/website/demos
RUN pip install --no-cache-dir -r requirements.txt
RUN python map_demos.py
RUN cp nginx.conf /etc/nginx/conf.d/default.conf

ENTRYPOINT nginx && python run_demos.py

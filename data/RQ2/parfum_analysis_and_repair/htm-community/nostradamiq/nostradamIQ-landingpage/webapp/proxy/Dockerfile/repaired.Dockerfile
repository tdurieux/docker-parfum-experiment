FROM redis:latest
RUN apt-get -y update && apt-get install --no-install-recommends -y python python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt
ADD . /proxy/
COPY * /proxy/
EXPOSE 8888
CMD redis-server & cd /proxy && python app.py --allow-proxy ALL --allow-origin ALL


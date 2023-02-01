FROM nginx:latest
RUN apt-get update -y && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir j2cli
COPY start /start
RUN chmod +x /start
COPY nginx.tmpl /nginx.tmpl
CMD /start
EXPOSE 80

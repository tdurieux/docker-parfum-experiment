FROM bg-image
RUN pip install --no-cache-dir carbon
ENTRYPOINT ["bg-carbon-cache"]
CMD ["--debug","--nodaemon","--conf=/conf/carbon.conf","start"]

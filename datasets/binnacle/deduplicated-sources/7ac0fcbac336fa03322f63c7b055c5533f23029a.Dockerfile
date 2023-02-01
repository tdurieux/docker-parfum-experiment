FROM {{BASE_IMAGE}}

# The ENTRYPOINT for mongo is at /usr/local/bin/docker-entrypoint.sh, but pre-3.6 images also	RUN mkdir /dev/shm/mongo
# include a symlink from /entrypoint.sh to that script. So, it's only necessary to update the real
# entrypoint file. This comment can be removed once all pre-3.6 mongo images are gone.
RUN sed -i '/exec "$@"/i mkdir \/dev\/shm\/mongo' /usr/local/bin/docker-entrypoint.sh

CMD ["mongod", "--nojournal", "--dbpath=/dev/shm/mongo"]

# QUICK START:
docker build -t flask_ub .; docker run -it --rm -v`pwd`/data.json:/home/appuser/app/data.json -v`pwd`/logs/:/home/appuser/app/logs/ -v`pwd`/users_sqlite.db:/home/appuser/app/users_sqlite.db --env-file .env --publish 5000:5000 flask_ub

# MANUAL start
docker build -t flask_ub .; docker run -it --rm -v`pwd`:/scratch -v`pwd`/data.json:/home/appuser/app/data.json -v`pwd`/logs/:/home/appuser/app/logs/ -v`pwd`/users_sqlite.db:/home/appuser/app/users_sqlite.db --env-file .env --entrypoint='' --publish 5000:5000 flask_ub /bin/bash

# where ".env" contains the variable defintions for GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET 



# Build the image
docker build -t flask_ub .

# run container in detached mode
docker run -d -p 5000:5000 flask_ub

# enter a running container
docker ps
docker exec -it 92348292 /bin/bash

# run container interactively
docker run -it --rm flask-ub /bin/bash
# Since I have a defined entrypoint, I use
docker run -it --rm --entrypoint /bin/bash flask_ub
# with a mount
docker run -it --rm --mount type=bind,source="$(pwd)",target=/another  --entrypoint /bin/bash flask_ub
# with ports exposed
docker run -it --rm --publish 5000:5000 --mount type=bind,source="$(pwd)",target=/another  --entrypoint /bin/bash flask_ub


# list all containers
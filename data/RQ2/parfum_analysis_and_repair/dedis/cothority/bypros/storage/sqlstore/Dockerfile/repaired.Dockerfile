# you can use this docker file to run a container with the right schema and env
# variables. Use `docker build .` to build an image. Then use it with:
# `docker run -p 5432:5432 -v ${PWD}/postgres:/var/lib/postgresql/data <docker ID>`
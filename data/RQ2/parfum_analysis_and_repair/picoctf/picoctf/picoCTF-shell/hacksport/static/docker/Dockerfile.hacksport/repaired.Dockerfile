# Stage 2. hacksport (local)
# This stage is intended to be built from within a virtualenv that has
# shell_manger/hacksport installed (e.g. /picoCTF-env). This is perhaps host
# specific (e.g. if you are modifying the base library) but for any given event
# should largely remain static and just require copying in.

FROM shellmanager/base

COPY . /picoCTF-env

# setup the environment shell_manager requires
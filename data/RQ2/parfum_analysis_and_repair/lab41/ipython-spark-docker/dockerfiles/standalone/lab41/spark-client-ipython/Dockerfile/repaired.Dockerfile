# build off base
FROM lab41/spark-base
MAINTAINER Kyle F <kylef@lab41.org>
ENV REFRESHED_AT 2015-07-29

# update workdir
WORKDIR /ipython

# add runit services
FROM jupyter/jupyterhub-onbuild

MAINTAINER Jupyter Project <jupyter@googlegroups.com>

RUN apt-get install --no-install-recommends -y libpq-dev \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && pip3 install --no-cache-dir psycopg2 && rm -rf /var/lib/apt/lists/*;

RUN useradd -m -G shadow -p $(openssl passwd -1 rhea) rhea
RUN chown rhea .

RUN for name in io ganymede ; do useradd -m -p $(openssl passwd -1 $name) $name; done

USER rhea

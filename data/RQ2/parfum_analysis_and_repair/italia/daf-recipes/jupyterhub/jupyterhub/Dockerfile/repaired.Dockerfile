FROM jupyterhub/jupyterhub

#POSTGRES DB PACKAGE
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        libpq-dev \
        npm \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && pip install --no-cache-dir psycopg2 \
 && apt-get install --no-install-recommends postgresql-client -y && rm -rf /var/lib/apt/lists/*;

# ADD LDAP AUTH PACKAGE
RUN pip install --no-cache-dir jupyterhub-ldapauthenticator
RUN pip install --no-cache-dir jupyterhub-ldapcreateusers


# Install Spark Magic library
RUN pip install --no-cache-dir sparkmagic

# Configure user home directory permission
COPY /ubuntuconfig /etc

# Init script spark magic
ADD ./sparkmagic-init.sh /
ADD ./wait_db_is_ready.sh /
RUN chmod +x /sparkmagic-init.sh
RUN chmod +x /wait_db_is_ready.sh

# ADD LOCAL ADMIN USER
RUN useradd -m -G shadow -p $(openssl passwd -1 admin) admin
RUN chown admin .

#Configure sparkmagic json file
COPY /sparkmagicconfig /etc/skel

#Install notebook
RUN pip install --no-cache-dir notebook

#EXPOSE 8000
#ENTRYPOINT ["jupyterhub"]

USER root

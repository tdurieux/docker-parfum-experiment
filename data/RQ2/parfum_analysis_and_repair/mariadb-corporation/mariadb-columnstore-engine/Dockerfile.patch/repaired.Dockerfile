45,48c45,46
< # Install MariaDB/ColumnStore packages
< RUN dnf -y install \
<     MariaDB-server \
<     MariaDB-columnstore-engine
---
> COPY *.rpm /
> RUN dnf -y install /*.rpm && rm -f /*.rpm
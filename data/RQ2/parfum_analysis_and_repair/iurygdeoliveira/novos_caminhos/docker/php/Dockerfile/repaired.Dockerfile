# INSTRUCTION arguments
# Docs: https://docs.docker.com/engine/reference/builder/


# WORKDIR:  É uma diretiva que define a pasta raiz para a execução dos
#           comandos RUN, CMD, ENTRYPOINT, COPY E ADD

# COPY:  É uma diretiva que copia um arquivo do host para dentro do container
#        Ex.: COPY <DIRETORIO DE ORIGEM> <DIRETORIO DE DESTINO>

# ENTRYPOINT: Permite você configurar um executável para o seu container

# EXPOSE: Informa o docker que o container irá escutar em uma porta tcp ou udp especifica
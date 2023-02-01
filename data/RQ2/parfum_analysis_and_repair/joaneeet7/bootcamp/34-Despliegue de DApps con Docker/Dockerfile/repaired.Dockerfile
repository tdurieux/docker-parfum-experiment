# Imagen base
FROM node:16.15.0

# Directorio de trabajo
WORKDIR /usr/src/app

# Copia del codigo dentro del contenedor
COPY . .

# Instalacion de los modulos
RUN npm install package.json && npm cache clean --force;
RUN npm install -g truffle@5.5.9 && npm cache clean --force;

# Exposicion de un puerto del contenedor
EXPOSE 3000

# Entrypoint para la ejecucion de la DApp
ENTRYPOINT [ "sh" ]
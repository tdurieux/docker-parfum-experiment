FROM {{ "node14" | image_tag }}

USER root
RUN npm install -g ajv-cli && npm cache clean --force;

USER nobody
WORKDIR /workspace
ENTRYPOINT ["ajv"]

FROM suborbital/atmo:v{{ .AtmoVersion }}

COPY ./runnables.wasm.zip .

ENTRYPOINT [ "atmo" ]
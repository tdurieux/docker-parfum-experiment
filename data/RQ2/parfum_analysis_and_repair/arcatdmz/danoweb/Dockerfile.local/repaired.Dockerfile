FROM arcatdmz/danoweb:latest

EXPOSE 8000
CMD cd /work/server && deno --allow-env --allow-net --allow-read --allow-write --unstable ./server.ts
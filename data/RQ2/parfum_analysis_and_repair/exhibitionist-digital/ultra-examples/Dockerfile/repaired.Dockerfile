FROM denoland/deno:1.20.6
EXPOSE 8000
RUN apt-get update && apt-get install --no-install-recommends -y jq moreutils && rm -rf /var/lib/apt/lists/*;
WORKDIR /
COPY . .
RUN deno task vendor
RUN jq '.importMap = "./vendorMap.json"' deno.json|sponge deno.json
CMD ["deno", "task", "start"]
FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y jq curl && rm -rf /var/lib/apt/lists/*;
ADD harpoon /harpoon
# run a infinite process for now, later we will have a simple service of sorts in place.
CMD ["tail", "-f", "/dev/null"]
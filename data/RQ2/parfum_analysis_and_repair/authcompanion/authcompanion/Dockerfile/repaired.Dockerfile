FROM denoland/deno:1.23.1

EXPOSE 3002

WORKDIR /app

# Cache the dependencies as a layer (the following two steps are re-run only when deps.ts is modified).
# Ideally cache deps.ts will download and compile _all_ external files used in cmd.ts.
COPY deps.ts .
RUN deno --unstable cache deps.ts

# These steps will be re-run upon each file change in your working directory:
ADD . .

# Compile authcompanion
RUN deno compile --output authcompanion -A --unstable bin/cmd.ts

# Start AuthC API Server
ENTRYPOINT [ "./authcompanion"]
FROM node:16
WORKDIR /app
COPY . .
RUN apt update && apt install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://unpkg.com/@pnpm/self-installer | node
RUN pnpm i
CMD ["pnpm", "start"]

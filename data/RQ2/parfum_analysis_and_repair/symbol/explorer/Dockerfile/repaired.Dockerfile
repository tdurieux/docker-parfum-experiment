FROM node:lts-alpine AS builder
WORKDIR /app
COPY . .
RUN npm install && npm run build && npm cache clean --force;

FROM node:lts-alpine AS runner
WORKDIR /app
COPY --from=builder /app /app
EXPOSE 4000
CMD ["npm", "start"]

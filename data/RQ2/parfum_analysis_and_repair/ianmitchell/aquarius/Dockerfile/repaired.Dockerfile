FROM node:14.9

# Setup Bot directory
WORKDIR /usr/src/bot

# Copy Aquarius
COPY . .

# Install Bot
RUN npm install && npm cache clean --force;

# Create Prisma Engine
RUN npx prisma generate

# Open the API
EXPOSE 3000

# Let's run it!
CMD [ "npm", "start" ]

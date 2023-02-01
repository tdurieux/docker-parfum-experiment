FROM leetcode_bot

# Override the NODE_ENV environment variable to 'dev', in order to get required test packages
ENV NODE_ENV dev

# Install test packages
RUN npm update

CMD ["npm", "test"]
# This dockerfile is to build each branch seperately (for dev purpouses)
FROM node:10
# Create Remix user, don't use root!
# RUN yes | adduser --disabled-password remix && mkdir /app
# USER remix

# #Now do remix stuff
# USER remix
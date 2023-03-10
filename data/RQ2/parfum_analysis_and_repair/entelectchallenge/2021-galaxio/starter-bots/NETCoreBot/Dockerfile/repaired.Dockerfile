# Base image provided by Entelect Challenge
FROM public.ecr.aws/m5z5a5b2/languages/dotnetcore:2021

WORKDIR /app

# The directory of the built code to copy into this image, to be able to run the bot.
COPY ./publish/ .

# The entrypoint to run the bot
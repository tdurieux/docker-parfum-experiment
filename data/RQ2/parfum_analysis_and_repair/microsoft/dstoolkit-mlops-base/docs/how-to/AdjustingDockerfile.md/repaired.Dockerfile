# Customizing the base docker image (mcr.microsoft.com/azureml/openmpi3.1.2-ubuntu18.04:20210922.v1) 
You have the option to specify your custom docker images for training and inference separately.

## First Step: Define your dockerfile
In case you need to upgrade/change packages in Linux (using for example apt-get install / apt-get update) or define additional commands you have the option to configure the Dockerfile on your own.

**[Environments](../../configuration/environments/)** contains two docker-related folders "environment_inference_dockerfile" and "environment_training_dockerfile" with the corresponding Dockerfile (BaseDockerfile). 

## Second Step: Change the environment path
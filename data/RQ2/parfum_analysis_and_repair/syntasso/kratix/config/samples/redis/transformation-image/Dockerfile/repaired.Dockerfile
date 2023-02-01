FROM lyft/kustomizer:v3.3.0
RUN [ "mkdir", "/transfer" ]
ADD patch.yaml /transfer/patch.yaml
ADD kustomization.yaml /transfer/kustomization.yaml

# To debug: 
#  kubectl get redis.redis.redis.opstreelabs.in opstree-redis --namespace default -oyaml > input/object.yaml
#  docker run -v `pwd`/input/:/input -v `pwd`/output/:/output syntasso/kustomize-redis
CMD [ "sh", "-c", "cp /transfer/* /input/; kustomize build /input/ > /output/output.yaml" ]
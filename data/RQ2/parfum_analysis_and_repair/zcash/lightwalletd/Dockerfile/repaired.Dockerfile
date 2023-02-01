# /************************************************************************
 #  File: Dockerfile
 #  Author: mdr0id
 #  Date: 9/3/2019
 #  Description:  Used for devs that have not built zcashd or lightwalletd on
 #                on existing system
 #  USAGE:
 #
 #  To build image: make docker_img
 #  To run container: make docker_image_run
 #  
 #  This will place you into the container where you can run zcashd, zcash-cli, 
 #  lightwalletd server etc..
 #
 #  First you need to get zcashd sync to current height on testnet, from outside container:
 #  make docker_img_run_zcashd
 #
 #  Sometimes you need to manually start zcashd for the first time, from inside the container:
 #  zcashd -printtoconsole   
 #
 #  Once the block height is at least 280,000 you can go ahead and start lightwalletd
 #  make docker_img_run_lightwalletd_insecure_server
 #  
 #  If you need a random bash session in the container, use:
 #  make docker_img_bash
 #
 #  If you get kicked out of docker or it locks up...
 #  To restart, check to see what container you want to restart via docker ps -a
 #  Then, docker restart <container id>
 #  The reattach to it, docker attach <container id>
 #
 #  Known bugs/missing features/todos:
 #
 #  *** DO NOT USE IN PRODUCTION ***
 #  
 #  - Create docker-compose with according .env scaffolding 
 #  - Determine librustzcash bug that breaks zcashd alpine builds at runtime
 #  - Once versioning is stable add config flags for images
 #  - Add mainnet config once lightwalletd stack supports it 
 #
 # ************************************************************************/

# Create layer in case you want to modify local lightwalletd code
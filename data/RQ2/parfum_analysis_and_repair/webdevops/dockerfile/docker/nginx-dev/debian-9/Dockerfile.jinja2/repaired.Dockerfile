{{ docker.from("nginx", "debian-9") }}

{{ environment.webDevelopment() }}

{{ docker.copy('conf/', '/opt/docker/') }}

{{ docker.expose('80 443') }}
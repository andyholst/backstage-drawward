# Backstage to Architecture Your Own Projects

This project uses a Dockerized Backstage CLI to create a Backstage app, then runs it in a container.

To be able to run Backstage in a container, you need to enable "Enable host networking
Host networking allows containers that are started with --net=host to use localhost to connect to TCP and UDP services on the host. It will automatically allow software on the host to use localhost to connect to TCP and UDP services in the container."

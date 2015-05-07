perforce-server
===============
[![Docker Build Status](http://hubstatus.container42.com/noonien/perforce-server)](https://registry.hub.docker.com/u/noonien/perforce-server)

This is a docker image for the [Perforce Helix Server](http://www.perforce.com/).

Usage
-----

    docker run -e PERFORCE_SERVER_NAME=server-name -e PERFORCE_PASSWORD=<password> noonien/perforce-server

Details
-------
The following environment variables are available:

  - PERFORCE_SERVER_NAME - Server name. Required.
  - PERFORCE_PROTOCOL - Server protocol. Described [here](http://www.perforce.com/perforce/doc.current/manuals/cmdref/P4PORT.html). Defaults to ssl.
  - PERFORCE_PORT - Server port. Defaults to 1666.
  - PERFORCE_USER - Superuser username. Only created when creating a new server. Defaults to perforce.
  - PERFORCE_PASSWORD - Superuser password. Required when creating a new server.

The path `/opt/perforce/server` is mounted as a volume because that's where the server roots are stored.

perforce-server
===============
[![Docker Build Status](http://hubstatus.container42.com/noonien/perforce-server)](https://registry.hub.docker.com/u/noonien/perforce-server)

This is a docker image for the [Perforce Helix Server](http://www.perforce.com/).

Usage
-----

    docker run -e SERVER_NAME=server-name -e P4PASSWD=<password> -p 1666:1666 noonien/perforce-server

Details
-------
The following environment variables are available:

  - SERVER_NAME - Server name. Required.
  - P4PORT - Address on which to listen. Described [here](http://www.perforce.com/perforce/doc.current/manuals/cmdref/P4PORT.html). Defaults to ssl:1666.
  - P4USER - Superuser username. Only created when creating a new server. Defaults to p4admin.
  - P4PASSWD - Superuser password. Required when creating a new server.

The path `/opt/perforce/server` is mounted as a volume because that's where the server roots are stored.

perforce-search
===============
[![Docker Build Status](http://hubstatus.container42.com/noonien/perforce-search)](https://registry.hub.docker.com/u/noonien/perforce-search)

This is a docker image for the [Perforce Search](http://www.perforce.com/).

Usage
-----

    docker run -e search_NAME=search-name -e P4PASSWD=<password> noonien/perforce-search

Details
-------
The following environment variables are available:

  - P4PORT - Address on which to listen. Described [here](http://www.perforce.com/perforce/doc.current/manuals/cmdref/P4PORT.html). Required.
  - P4USER - Superuser username. Only created when creating a new search. Required.
  - P4PASSWD - Superuser password. Required when creating a new search. Required.
  - P4TOKEN - Token to use when receving pushes from perforce. Required.
  - P4CHARSET - Server charset. Optional.

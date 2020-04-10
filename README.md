docker-perforce
===============
[![License: MIT](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/noonien/docker-perforce-server/blob/master/LICENSE)

Quick and easy way of setting up a Perforce Helix server using [docker-compose](https://docs.docker.com/compose/).

## How to get started

1.   - Clone this repo
2.   - Create a `.env` file inside the repo's root directory.
3.   - Set the following environment variables to your desired values **(must be in `VARNAME=VALUE` format!)**.

* **P4USER**  -  default is `p4admin`
* **P4PORT**  -  default is `ssl:1666`
* **P4PORTNUM**  -  default is `1666`
* * This should be the same number as the one used in your **P4PORT** string.
* **P4PASSWD**  -  Don't use a default value; please choose a super **strong** password!
* **P4DOCKERVOL**  -  default is `/mnt/dockervolumes/perforce`
* * This is where the docker volume will be mounted to on your host machine. Your entire perforce server instance lives inside there. It's therefore recommended to pick a path with abundant disk space...
* **SERVER_NAME**  -  default is `p4dsrv`

4.   - Open the p4d port (default is port number 1666)
5.   - Install [Docker Engine](https://docs.docker.com/engine/install/) and [docker-compose](https://docs.docker.com/compose/install/) if you haven't already.
6.   - run `sudo docker-compose up -d` 

Your server should now be up and running, listening to the specified port, using the specified user credentials.

If anything goes wrong and your server doesn't work, run `sudo docker-compose down --remove-orphans` and then `sudo docker-compose up`.
Without the `-d` argument, you will see what's logged to the terminal and act accordingly. Once everything works, `Ctrl + C` (this shuts the helix server down) and then you can proceed to repeat step 6 above.

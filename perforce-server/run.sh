#!/bin/bash
set -e

# Perforce paths
CONFIGURE_SCRIPT=/opt/perforce/sbin/configure-perforce-server.sh
PERFORCE_SERVERS_ROOT=/opt/perforce/servers
PERFORCE_CONFIG_ROOT=/etc/perforce/p4dctl.conf.d

# Theese need to be defined
if [ -z "$PERFORCE_SERVER_NAME" ]; then
    echo FATAL: PERFORCE_SERVER_NAME not defined 1>&2
    exit 1;
fi
if [ -z "$PERFORCE_PASSWORD" ]; then
    echo FATAL: PERFORCE_PASSWORD not defined 1>&2
    exit 1;
fi

# Default values
PERFORCE_USER=${PERFORCE_USER:-p4admin}
PERFORCE_PROTOCOL=${PERFORCE_PROTOCOL:-ssl}
PERFORCE_PORT=${PERFORCE_PORT:-1666}

# Check if the server was configured. If not, configure it.
if [ ! -f $PERFORCE_CONFIG_ROOT/$PERFORCE_SERVER_NAME.conf ]; then
    echo Perforce server $PERFORCE_SERVER_NAME not configured, configuring.

    # If the root path already exists, we're configuring an existing server
    PERFORCE_SERVER_ROOT=$PERFORCE_SERVERS_ROOT/$PERFORCE_SERVER_NAME
    $CONFIGURE_SCRIPT -n \
        -r $PERFORCE_SERVER_ROOT \
        -p $PERFORCE_PROTOCOL:$PERFORCE_PORT \
        -u $PERFORCE_USER \
        -P $PERFORCE_PASSWORD \
        $PERFORCE_SERVER_NAME

    echo Server info:
    p4 -p $PERFORCE_PROTOCOL:$PERFORCE_PORT info
else
    # Configuring the server also starts it, if we've not just configured a
    # server, we need to start it ourselves.
    p4dctl start ${PERFORCE_SERVER_NAME}
fi

# Pipe server log and wait until the server dies
PID_FILE=/var/run/p4d.$PERFORCE_SERVER_NAME.pid
exec /usr/bin/tail --pid=$(cat $PID_FILE) -n 0 -f "$PERFORCE_SERVER_ROOT/log"

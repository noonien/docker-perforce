#!/bin/bash
set -e

# Perforce paths
CONFIGURE_SCRIPT=/opt/perforce/sbin/configure-helix-p4d.sh
SERVERS_ROOT=/opt/perforce/servers
CONFIG_ROOT=/etc/perforce/p4dctl.conf.d

chmod +x $CONFIGURE_SCRIPT

# These need to be defined
if [ -z "$SERVER_NAME" ]; then
    echo FATAL: SERVER_NAME not defined 1>&2
    exit 1;
fi
if [ -z "$P4PASSWD" ]; then
    echo FATAL: P4PASSWD not defined 1>&2
    exit 1;
fi

# Default values
P4USER=${P4USER:-p4admin}
P4PORT=${P4PORT:-ssl:1666}

SERVER_ROOT=$SERVERS_ROOT/$SERVER_NAME
# Check if the server was configured. If not, configure it.
if [ ! -f $CONFIG_ROOT/$SERVER_NAME.conf ]; then
    echo Perforce server $SERVER_NAME not configured, configuring.

    # If the root path already exists, we're configuring an existing server
    $CONFIGURE_SCRIPT -n \
        -r $SERVER_ROOT \
        -p $P4PORT \
        -u $P4USER \
        -P $P4PASSWD \
        $SERVER_NAME

    echo Server info:
    p4 -p $P4PORT info
else
    # Configuring the server also starts it, if we've not just configured a
    # server, we need to start it ourselves.
    p4dctl start $SERVER_NAME
fi

# Pipe server log and wait until the server dies
PID_FILE=/var/run/p4d.$SERVER_NAME.pid
exec /usr/bin/tail --pid=$(cat $PID_FILE) -n 0 -f "$SERVER_ROOT/logs/log"

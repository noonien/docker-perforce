#!/bin/bash

for config in P4PORT P4USER P4PASSWD P4TOKEN; do
    if [ -z "${!config:-}" ]; then
        echo FAIL: $config not defined 1>&2
        exit 1
    fi
done


# Trust the server when connecting over ssl
if [[ $P4PORT == "ssl"* ]]; then
    echo SSL connection detected, establishing trust
    if ! p4 trust -y; then
        echo FAIL: Could not establish trust for $P4PORT 1>&2
        exit 1
    fi
fi

# Check login
if ! echo $P4PASSWD | p4 login > /dev/null; then
    echo FAIL: Could not login using provided user/password
    exit 1
fi

cd /opt/perforce/search

# Configure files
## Server connection details
PROTOCOL=none
HOST=127.0.0.1
parts=(${P4PORT//:/ })
case ${#parts[@]} in
    1)
        PORT=${parts[0]}
        ;;
    2)
        HOST=${parts[0]}
        PORT=${parts[1]}
        ;;
    3)
        PROTOCOL=${parts[0]}
        HOST=${parts[1]}
        PORT=${parts[2]}
        ;;
esac

sed -i 's/\(serverProtocol\)=.*/\1='$PROTOCOL'/' jetty/resources/search.config
sed -i 's/\(serverHost\)=.*/\1='$HOST'/' jetty/resources/search.config
sed -i 's/\(serverPort\)=.*/\1='$PORT'/' jetty/resources/search.config
sed -i 's/\(indexerUser\)=.*/\1='$P4USER'/' jetty/resources/search.config
sed -i 's/\(indexerPassword\)=.*/\1='$P4PASSWD'/' jetty/resources/search.config
if [ ! -z "$P4CHARSET" ]; then
    sed -i 's/\(serverCharset\)=.*/\1='$P4CHARSET'/' jetty/resources/search.config
fi
if [ ! -z "$P4COMMONSURL" ]; then
    sed -i 's>^\(# \|\)\(com.perforce.search.commonsURL\)=.*>\2='$P4COMMONSURL'>' jetty/resources/search.config
fi
if [ ! -z "$P4WEBURL" ]; then
    sed -i 's>^\(# \|\)\(com.perforce.search.webURL\)=.*>\2='$P4WEBURL'>' jetty/resources/search.config
fi
if [ ! -z "$P4SWARMURL" ]; then
    sed -i 's>^\(# \|\)\(com.perforce.search.swarmURL\)=.*>\2='$P4SWARMURL'>' jetty/resources/search.config
fi

# Token
sed -i 's/^# \(com.perforce.search.fileScannerToken\)/\1/' jetty/resources/search.config
sed -i 's/\(searchEngineToken\)=.*/\1='$P4TOKEN'/' jetty/resources/search.config

## Solr config
sed -i 's/^JPORT=.*/JPORT=8983/' solr/example/solr-control.sh
sed -i 's/^STOP=.*/STOP=8984/' solr/example/solr-control.sh

# Start solr and jetty/p4search
solr/example/solr-control.sh start
jetty/p4search-control.sh start

JETTY_PID=$(ps axf | grep jetty/start.jar | grep -v grep | awk '{print $1}')
tail --pid=$JETTY_PID -f start.log logs/solr.log

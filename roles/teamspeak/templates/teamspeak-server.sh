#! /bin/sh
### BEGIN INIT INFO
# Provides:             teamspeak-server
# Required-Start:       $network $local_fs $remote_fs $syslog
# Required-Stop:        $network #local_fs $remote_fs $syslog
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    TeamSpeak 3 server
# Description:          init script for TeamSpeak 3 server
### END INIT INFO

# Author: Dharma Bellamkonda <dharma.bellamkonda@gmail.com>

g_COMMAND="$1"

g_USER="teamspeak"
g_TS3_HOME="/home/teamspeak/teamspeak-server-{{ teamspeak_version }}/teamspeak3-server_linux-amd64"
g_STARTSCRIPT="$g_TS3_HOME/ts3server_startscript.sh"

cd "$g_TS3_HOME"
RETVAL=0

status() {
  sudo -u "$g_USER" "$g_STARTSCRIPT" status | grep "Server is running" | grep -v grep
  return $?
}

restart() {
  sudo -u "$g_USER" "$g_STARTSCRIPT" restart
  return $?
}

case "$g_COMMAND" in
    status)
        status
        if [ $? -eq 0 ]; then
          echo "Teamspeak is running"
          RETVAL=0
        else
          echo "Teamspeak is stopped"
          RETVAL=1
        fi
        ;;
    start)
        echo "Starting TeamSpeak 3 server..."
        sudo -u "$g_USER" "$g_STARTSCRIPT" start
        RETVAL=$?
        ;;
    stop)
        echo "Stopping TeamSpeak 3 server..."
        status
        if [ $? -eq 0 ]; then
          sudo -u "$g_USER" "$g_STARTSCRIPT" stop
          RETVAL=$?
        else
          echo "Already stopped"
        fi
        ;;
    reload)
        echo "Reload is not supported. Restarting instead..."
        restart
        ;;
    force-reload)
        echo "Reload is not supported. Restarting instead..."
        restart
        ;;
    restart)
        echo "Restarting TeamSpeak 3 server..."
        restart
        ;;
    *)
        echo "Usage: $0 {status|start|stop|restart}"
        RETVAL=2
        ;;
esac

exit $RETVAL

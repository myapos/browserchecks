#!/bin/sh

#BROWSER='wget'
#BROWSER_OPTIONS='-O /dev/null -o /dev/null'

BROWSER='firefox'
BROWSER_OPTIONS='-headless'
DELAY=5
SITE='http://google.com'

makeAndKillBrowsers() {
  $BROWSER $BROWSER_OPTIONS $SITE &
  echo "waiting $DELAY seconds"
  sleep $DELAY
  getAndKillRunningBrowserPids
}

getAndKillRunningBrowserPids() {
  echo "preparing to kill all browser $BROWSER processes"
  for i in $(pgrep $BROWSER)
  do
    echo "killing now process $i....."
    kill -9 $i
  done
}

for i in $(seq 1 10)
do
  echo "opening browser $i"
  makeAndKillBrowsers
done
echo "done"

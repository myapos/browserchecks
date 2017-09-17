#!/bin/bash

#BROWSER='wget'
#BROWSER_OPTIONS='-O /dev/null -o /dev/null'
#CLI arguments 
#first argument is browser to run page visit ex. chrome, firefox
#second argument is the page to visit

#BROWSER='firefox'
BROWSER=$1
SITE=$2
NUMOFBROWSERS=$3
DELAY=$4

BROWSER_OPTIONS_FIREFOX='-private-window -headless'
BROWSER_OPTIONS_CHROME='--headless --remote-debugging-port=9222 --disable-gpu --incognito'
BROWSER_OPTIONS_CHROMIUM='--incognito'
#BROWSER_OPTIONS='-headless'

makeAndKillBrowsers() {
  echo "running in $BROWSER mode"

  #if [ "$BROWSER" = "chrome" ]; then
  #[[ "$date" =~ "[0-9]\{8\}" ]];
  #  if echo $BROWSER | grep "[/chrome/]"; then
  if [[ "$BROWSER" =~ chrome ]]; then
     "google-$BROWSER" $BROWSER_OPTIONS_CHROME $SITE &
     echo "waiting $DELAY seconds"
     sleep $DELAY
     getAndKillRunningBrowserPids
  elif [[ "$BROWSER" =~ firefox ]]; then
      $BROWSER $BROWSER_OPTIONS_FIREFOX $SITE &
      echo "waiting $DELAY seconds"
      sleep $DELAY
      getAndKillRunningBrowserPids
  elif [[ "$BROWSER" =~ chromium ]]; then
      "$BROWSER-browser" $BROWSER_OPTIONS_CHROMIUM $SITE &
      echo "waiting $DELAY seconds"
      sleep $DELAY
      getAndKillRunningBrowserPids
  else
    echo "Please give right arguments. Available options are chrome, chromium, firefox."
  fi
}

getAndKillRunningBrowserPids() {
  echo "preparing to kill all browser $BROWSER processes"
  if [[ "$BROWSER" =~ chrome ]]; then
     NEEDLE="chrome"
  elif [[ "$BROWSER" =~ chromium ]]; then
    NEEDLE="chromium-browse"
  else
     NEEDLE="firefox"
  fi

  for i in $(pgrep $NEEDLE)
  do
    echo "killing now process $i....."
    kill -9 $i
  done
}

for i in $(seq 1 $NUMOFBROWSERS)
do
  echo "opening browser $NUMOFBROWSERS"
  makeAndKillBrowsers
done
echo "done"

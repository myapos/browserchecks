#!/bin/bash

#BROWSER='wget'
#BROWSER_OPTIONS='-O /dev/null -o /dev/null'
#CLI arguments 
#first argument is browser to run page visit ex. chrome, firefox
#second argument is the page to visit
#third argument is the number of browsers
#fourth argument is delay in seconds

BROWSER=$1
SITE=$2
NUMOFBROWSERS=$3
DELAY=$4

BROWSER_OPTIONS_FIREFOX='-private-window -headless'
BROWSER_OPTIONS_CHROME='--headless --remote-debugging-port=9222 --disable-gpu --incognito'
BROWSER_OPTIONS_CHROMIUM='--incognito'

makeAndKillBrowsers() {
  echo "running in $BROWSER mode"

  if [[ "$BROWSER" =~ chrome ]]; then
     "google-$BROWSER" $BROWSER_OPTIONS_CHROME $SITE &
     getAndKillRunningBrowserPids
  elif [[ "$BROWSER" =~ firefox ]]; then
      $BROWSER $BROWSER_OPTIONS_FIREFOX $SITE &
      getAndKillRunningBrowserPids
  elif [[ "$BROWSER" =~ chromium ]]; then
      "$BROWSER-browser" $BROWSER_OPTIONS_CHROMIUM $SITE &
      getAndKillRunningBrowserPids
  else
    echo "Please give right arguments. Available options are chrome, chromium, firefox."
  fi
}

getAndKillRunningBrowserPids() {
  echo "waiting $DELAY seconds"
  sleep $DELAY
  
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
    echo "Killing $i"
    kill $i 
    wait $i 2> /dev/null
  done
}

for i in $(seq 1 $NUMOFBROWSERS)
do
  echo "opening browser $i"
  makeAndKillBrowsers
done
echo "done"

#!/bin/bash

#BROWSER='wget'
#BROWSER_OPTIONS='-O /dev/null -o /dev/null'
#CLI arguments 
#first argument is browser to run page visit ex. chrome, firefox
#second argument is browser to run page visit ex. chrome, firefox
#third argument is the page to visit
#fourth argument is the number of browsers
#fifth argument is delay in seconds

BROWSER=$1
SITE1=$2
SITE2=$3
NUMOFBROWSERS=$4
DELAY=$5


BROWSER_OPTIONS_FIREFOX='-private-window -headless'
BROWSER_OPTIONS_CHROME1='--headless --remote-debugging-port=9222 --disable-gpu --incognito'
BROWSER_OPTIONS_CHROME2='--headless --new-window --remote-debugging-port=9223 --disable-gpu --incognito'
BROWSER_OPTIONS_CHROMIUM='--incognito'

makeAndKillBrowsers() {
  echo "running in $BROWSER mode"

  if [[ "$BROWSER" =~ chrome ]]; then
     "google-$BROWSER" $BROWSER_OPTIONS_CHROME1 $SITE1 &
     "google-$BROWSER" $BROWSER_OPTIONS_CHROME2 $SITE2 &
     getAndKillRunningBrowserPids
  elif [[ "$BROWSER" =~ firefox ]]; then
      $BROWSER $BROWSER_OPTIONS_FIREFOX $SITE1 &
      $BROWSER $BROWSER_OPTIONS_FIREFOX $SITE2 &
      getAndKillRunningBrowserPids
  elif [[ "$BROWSER" =~ chromium ]]; then
      "$BROWSER-browser" $BROWSER_OPTIONS_CHROMIUM $SITE1 &
      "$BROWSER-browser" $BROWSER_OPTIONS_CHROMIUM $SITE2 &
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

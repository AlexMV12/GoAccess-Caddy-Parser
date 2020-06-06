#!/bin/bash

today_date=$(date -u +"%Y-%m-%d")
today_ts=$(date -d $today_date +%s)

goaccess <(cat website_on_caddy.log | jq --raw-output '
   .request.remote_addr |= .[:-6] | 
   select(.request.remote_addr != "1.2.3.4") | 
   select(.ts >= '$today_ts') | 
   [
      .common_log,
      .request.headers.Referer[0] // "-",
      .request.headers."User-Agent"[0],
      .duration
   ] | @csv') \
   --log-format='"%h - - [%d:%t %^] ""%m %r %H"" %s %b","%R","%u",%T' --time-format='%H:%M:%S' --date-format='%d/%b/%Y'


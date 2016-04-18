#!/bin/sh
# Found at http://staff.washington.edu/corey/tools/crontab-timeline
# Kommando zum Ausführen (Datei muss vorher mit chmod ausführbar gemacht werden z.B. mit 777 für alle)
# crontab -l | crontab-timeline.sh
#
# Reads and expands a crontab into a 24hour timeline:
#
# For each scheduled cron event...
# ... outputs the event's time (hh:mm) followed by the event's crontab entry
#
# This output is sorted into a cron event timeline (however it is still
# up to the reader to decode/determine which events run on which days).
#
# Corey Satten, corey@cac.washington.edu, 11/18/97
# http://staff.washington.edu/corey

awk '
    BEGIN   {
	    E24 = "0"; for(i=01; i<24; ++i) E24 = E24 "," i
	    E60 = E24; for(i=24; i<60; ++i) E60 = E60 "," i
	    }

    /^#/    {next}

	    {
	    if ($1 == "*") n_minutes = split(E60, minute, ",")
	    else           n_minutes = split($1, minute, ",")

	    if ($2 == "*") n_hours = split(E24, hour, ",")
	    else           n_hours = split($2, hour, ",")

	    for (h = 1; h <= n_hours; ++h)
		for (m = 1; m <= n_minutes; ++m)
		    printf("%02d:%02d\t%s\n", hour[h], minute[m], $0)
	    }
	' $* | sort
#!/bin/bash

grep -E ].[\(]WW\) /var/log/Xorg.0.log | sed -E "s/\(WW\)/Warning: /" > full.log
grep -E ].[\(]II\) /var/log/Xorg.0.log | sed -E "s/\(II\)/Information: /" >> full.log
cat full.log

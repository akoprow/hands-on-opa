#!/bin/bash
for i in `find -name '*.exe'`; do upx -9 $i; done

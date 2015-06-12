#!/bin/sh

OPTIONS=`vagrant ssh-config | awk -v ORS=' ' '{print "-o " $1 "=" $2}'`

scp -rp ${OPTIONS} "$@" || echo "Transfer failed. Did you use 'default:' as the target?"


#!/bin/sh
exec scala "$0" "$@"
!#

import sys.process._

object extends App {

    "mysql -u dbmeteodb -p dbmeteodb < ../sql/puerto_rico_aot_ae_sounding.sql > ../data/puerto_rico_aot_ae_sounding.txt" !
    
}

sed  -i sql.bak 's/as height/as height, avg(snkt) as snkt, avg(drct) as drct /' *.sql
sed -i sql.bak 's/dwpt/dwpt, avg(height) as height /' *.sql 
sed -i sql.bak 's/rh/rh, avg(dwpt) as dwpt /' *.sql 

sed -E -i sql.bak 's/and[[:space:]]+and/and/' *.sql
sed -E -i txt.bak 's/^/#/' *.txt 

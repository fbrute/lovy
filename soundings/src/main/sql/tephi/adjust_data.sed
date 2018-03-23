sed -i sql.bak 's/rh/rh, avg(dwpt) as dwpt /' *.sql 
sed -E -i sql.bak 's/and[[:space:]]+and/and/' *.sql
sed -E -i txt.bak 's/^/#/' *.txt 

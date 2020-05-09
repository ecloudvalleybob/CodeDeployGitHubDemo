#!/bin/bash

result=$(curl -L --insecure -s -I --max-time 30 localhost | tee /tmp/validate_out | grep ^HTTP | tail -n 1)

if [[ "$result" =~ "200" ]]; then
    echo http 200
    exit 0
elif [[  "$result" =~ "504" ]]; then
    echo 504 Gateway Time-out
    exit 1
elif [[ "$result" =~ "400" ]]; then
    echo 400 Bad Request
    exit 1
elif [[ "$result" =~ "500" ]]; then
    cat /tmp/validate_out
    echo Error Logs as Follows: /var/log/php/php_error.log
    sudo tail -n 1 /var/log/php/php_error.log
    exit 1
elif [[ "$result" =~ "Operation now in progress" ]]; then
    echo $result
    exit 1
else
    cat /tmp/validate_out
    echo something error, please check
    exit 1
fi
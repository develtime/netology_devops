# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

1. Переменная `c` будет равна строке `a+b` так как не использовались никакие спецсимволы, то мы просто присвоили строку, переменная `d` будет равна строке `1+2` в данном случае используется спецсимвол подстановки переменной, но не используется подстановка результата вычисления `$(())` и по вышеуказанной причине переменная `e` будет равна `3`.
2. Данный в задаче скрипт, опрашивает сайт и в случае ошибки пишет дату проверки в лог, но никогда не выходит из цикла, даже в случае успешной проверки. Я бы предложил следующий вариант:

   ```sh
    #!/usr/bin/env bash
    while ((1 == 1)); do
        curl https://localhost:4757
        if (($? != 0)); then
            #пишем дату последней проверки
            echo Site is down: $(date) >curl.log
        else
            echo Site is up: $(date) >curl.log
            #выходим из цикла, если сайт успешно отвечает
            break
        fi
    done
   ```

   p.s. не совсем понял почему `место на жёстком диске постоянно уменьшается` в неправильной версии скрипта, ведь если сайт будет поднят, то скрипт никогда не завершится, но и писать в лог ничего не будет.

3. Проверка доступности IP адресов по порту 80 с записью в лог

   ```sh
    #!/usr/bin/env bash
    port=80
    echo "Start new check on: $(date)" >>ip_address_status.log
    for ip in "192.168.0.1" "173.194.222.113" "87.250.250.242"; do
        i=0
        while (($i < 5)); do
            status=available
            nc -zw1 $ip $port
            if (($? != 0)); then
                status=unavailable
            fi

            echo IP Address $ip is $status on port $port >>ip_address_status.log
            i=$(($i + 1))
        done
    done
   ```

4. Проверка доступности IP адресов по порту 80 с выходом из скрипта при обнаружении первого недоступного адреса

   ```sh
    #!/usr/bin/env bash
    i=1
    port=80
    echo "Start new check on: $(date)" >>ip_address_error.log

    while (($i == 1)); do
        for ip in "192.168.0.1" "173.194.222.113" "87.250.250.242"; do
            nc -zw1 $ip $port
            if (($? != 0)); then
                echo IP Address $ip is unavailable on port $port >>ip_address_error.log
                i=0
                break
            fi
        done
    done
   ```
5. Пример хука `commit-msg`

   ```sh
    #!/usr/bin/env bash
    MSG="$1"
    MAX_LEN=30
    LEN=${#MSG}
    PATTERN="[04-script-01-bash]: "

    if ! [[ "$MSG" == "$PATTERN"* ]]; then
        echo "Bad commit message, see example: [04-script-01-bash]: Commit message."
        exit 1
    fi

    if [[ $LEN -gt $MAX_LEN ]]; then
        echo "Bad commit message. Maximum message length is $MAX_LEN"
        exit 1
    fi
   ```
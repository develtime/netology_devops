# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

1. Ошибки API сервиса:
    - Везде лишний пробел после `ключа`
    - В значении ключа `info` незаэкранирован системный символ таба
    - Нет пробела перед значением ключа `elements`
    - Второй ключ `ip` массива `elements` не закрыт
    - Значение второго ключа `ip` массива `elements` не обернуто в ковычки

   ```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175
            },
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
   ```

   ```json
    {
        "info": "Sample JSON output from our service\\t",
        "elements": [
            {
                "name": "first",
                "type": "server",
                "ip": 7175
            },
            {
                "name": "second",
                "type": "proxy",
                "ip": "71.78.22.43"
            }
        ]
    }
   ```
2. Доработанный скрипт из прошлого задания

    ```py
    #!/usr/bin/env python3

    import os
    import socket
    import json
    import yaml

    # History file name
    hist_name_json = 'servers.json'
    hist_name_yaml = 'servers.yml'

    # Hosts for check
    hosts = ['drive.google.com', 'mail.google.com', 'google.com']

    # Dictionaries
    latest = {}
    current = {}

    # Try to read old data
    if os.path.exists(hist_name_json):
        with open(hist_name_json) as json_file:
            latest = json.load(json_file)

    for hostname in hosts:
        host_info = socket.gethostbyname_ex(hostname)
        current[hostname] = host_info[-1][0]

        # Just console output data
        for host_ip in host_info[-1]:
            print(f'[INFO]: URL: "{hostname}", IP: "{host_ip}"')

        # Check if old ip isn't equal new ip
        if hostname in latest.keys() and current[hostname] != latest[hostname]:
            print('##############################################')
            print(f'[ERROR]: "{hostname}" IP mismatch: {latest[hostname][0]} {host_info[-1][0]}')

    # Save new history in JSON format
    with open(hist_name_json, 'w') as outfile:
        json.dump(current, outfile, indent=2)

    # Save new history in YAML format
    with open(hist_name_yaml, 'w') as outfile:
        yaml.dump(current, outfile, explicit_start=True, explicit_end=True)
    ```

3. Скрипт для команды которая не может прийти к соглашению

    ```py
    #!/usr/bin/env python3

    import os
    import json
    import yaml
    from argparse import ArgumentParser


    parser = ArgumentParser(description='Git status script parameters.')

    parser.add_argument("-f", "--file", dest="file",
                        help="JOSN/YAML file to convert", type=str, metavar="INPUT_CONVERT_FILE", required=True)

    args = parser.parse_args()

    if not os.path.exists(args.file):
        print(f"ERROR: File {args.file} doesn't exists")
        exit(1)

    # Get file name without extension
    file_name = os.path.splitext(args.file)[0]

    is_json = True
    is_yaml = False
    raw_file = ""
    file_data = {}

    # Read source file into memory
    with open(args.file, "r") as input_file:
        raw_file = input_file.read()

    # Trying to map file as JSON
    try:
        file_data = json.loads(raw_file)
    except ValueError as ex:
        is_json = False
        print(f"ERROR: File is not valid JSON format. {ex}")
        print("Trying to load file as YAML format...")

    # If file is not JSON then trying to map files as YAML
    if not is_json:
        try:
            file_data = yaml.load(raw_file, Loader=yaml.FullLoader)
            is_yaml = True
        except yaml.scanner.ScannerError as ex:
            print(f"ERROR: File is not valid YAML format. {ex}")
            exit(1)

    # Save file as YAML 
    if is_json:
        with open(f"{file_name}.yml", 'w') as outfile:
            yaml.dump(file_data, outfile, explicit_start=True, explicit_end=True)
        print(f"Save as: {file_name}.yml")
    # Else save as JSON
    else:
        with open(f"{file_name}.json", 'w') as outfile:
            json.dump(file_data, outfile, indent=2)
        print(f"Save as: {file_name}.json")
    ```
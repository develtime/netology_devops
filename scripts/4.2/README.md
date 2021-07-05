# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

1. В данном примере переменной `c` не будет присвоено никакое значение, т.к. производится операция сложения без приведения типов, что вызовет исключение.

   Для того что-бы получить значение 12:

   ```py
   c = int(f'{a}{b}')
   ```

   Для того что-бы получить значение 3:

   ```py
   c = a + int(b)
   ```

2. Для того что бы узнать состояние модифицированых файлов в локальном репозитории, я бы изменил скрипт следующим образом:

   ```py
    #!/usr/bin/env python3

    import os
    git_rel_path = "~/netology/sysadm-homeworks"
    git_abs_path = f"{os.path.expanduser('~')}/{git_rel_path.replace('~/', '')}"

    bash_command = [f"cd {git_abs_path}", "git status -s"]
    result_os = os.popen(' && '.join(bash_command)).read()

    for result in result_os.split('\n'):
        if result.startswith(' M'):
            prepare_result = result.replace(' M ', '')
            print(f"Modified: {git_abs_path}/{prepare_result}")
   ```

3. Более гибкая версия скрипта

   ```py
    #!/usr/bin/env python3

    import os
    import subprocess as sp
    from argparse import ArgumentParser

    parser = ArgumentParser(description='Git status script parameters.')

    parser.add_argument("-d", "--directory", dest="directory",
                        help="Git repository directory path. (default: ./)", type=str, metavar="GIT_STATUS_PATH", default="./")

    parser.add_argument("-s", "--states", dest="states", nargs='+',
                        help="Git status states to checking [new, mod, del, untrack]. (default: mod)", type=str, default="mod")

    args = parser.parse_args()

    if 'all' in args.states:
        args.states = ['new', 'mod', 'del', 'untrack']

    if not os.path.exists(args.directory):
        print(f"ERROR: Directory {args.directory} doesn't exists")
        exit(1)

    git_abs_path = os.path.abspath(args.directory)

    os.chdir(git_abs_path)

    proc = sp.Popen(['git', 'status', '-s'], stdout=sp.PIPE, stderr=sp.PIPE, universal_newlines=True)

    proc.wait()

    if proc.returncode == 128:
        print("ERROR: Directory is not git repository")
        exit(proc.returncode)

    proc_results = proc.communicate()[0]

    for result in proc_results.split('\n'):
        if result.startswith('A') and 'new' in args.states:
            prepare_result = result.replace('A ', '')
            print(f"New file: {git_abs_path}/{prepare_result}")
        elif result.startswith(' M') and 'mod' in args.states:
            prepare_result = result.replace(' M ', '')
            print(f"Modified: {git_abs_path}/{prepare_result}")
        elif result.startswith(' D') and 'del' in args.states:
            prepare_result = result.replace(' D ', '')
            print(f"Deleted: {git_abs_path}/{prepare_result}")
        elif result.startswith('??') and 'untrack' in args.states:
            prepare_result = result.replace('?? ', '')
            print(f"Untracked: {git_abs_path}/{prepare_result}")
   ```

4. Скрипт для проверки доменных имен и их IP адресов:

   ```py
    #!/usr/bin/env python3

    import os
    import socket
    import json

    # History file name
    hist_name = 'servers.json'

    # Hosts for check
    hosts = ['drive.google.com', 'mail.google.com', 'google.com']

    # Dictionaries
    latest = {}
    current = {}

    # Try to read old data
    if os.path.exists(hist_name):
        with open(hist_name) as json_file:
            latest = json.load(json_file)

    for hostname in hosts:
        host_info = socket.gethostbyname_ex(hostname)
        current[hostname] = []
        # Just console output data
        for host_ip in host_info[-1]:
            print(f'[INFO]: URL: "{hostname}", IP: "{host_ip}"')
            current[hostname].append(host_ip)
        # Check if old ip isn't equal new ip
        if hostname in latest.keys() and len(latest[hostname]) > 0 and host_info[-1][0] != latest[hostname][0]:
            print('##############################################')
            print(f'[ERROR]: "{hostname}" IP mismatch: {latest[hostname][0]} {host_info[-1][0]}')

    # Save new history
    with open('servers.json', 'w') as outfile:
        json.dump(current, outfile)
   ```

5. Пример `Github Pull Request` утилиты

   ```py
   #!/usr/bin/env python3

   import os
   import subprocess as sp
   from argparse import ArgumentParser

   from github import Github # Github API module `pip install PyGithub`
   from github import GithubException

   token = '<TOKEN>'
   remote_account = '<ACCOUNT>'
   remote_repo = '<REPOSITORY>'
   remote_project = f'{remote_account}/{remote_repo}'

   parser = ArgumentParser(description='Git pull request script parameters.')

   parser.add_argument("-d", "--directory", dest="directory",
                       help="Git repository directory path. (default: ./)", type=str, metavar="GIT_LOCAL_PATH", default="./")

   parser.add_argument("-m", "--message", dest="message",
                       help="Pull request message", type=str, metavar="GIT_PULL_REQUEST_MESSAGE", required=True)

   parser.add_argument("-c", "--commit", dest="commit",
                       help="Create and Push new branch", type=str, metavar="GIT_COMMIT_BRANCH", default="")

   parser.add_argument("-b", "--branch", dest="branch",
                       help="Create and Push new branch", type=str, metavar="GIT_PR_BRANCH", default="")

   args = parser.parse_args()

   if not os.path.exists(args.directory):
       print(f"ERROR: Directory {args.directory} doesn't exists")
       exit(1)

   git_abs_path = os.path.abspath(args.directory)

   os.chdir(git_abs_path)

   proc = sp.Popen(['git', 'branch', '--show-current'],
                   stdout=sp.PIPE, stderr=sp.PIPE, universal_newlines=True)

   proc.wait()

   if proc.returncode == 128:
       print("ERROR: Directory is not git repository")
       exit(proc.returncode)

   # Set default local branch name
   local_git_branch = proc.communicate()[0].replace('\n', '')

   # Custom branch name
   if args.branch != "":
       proc = sp.Popen(['git', 'checkout', '-b', args.branch],
                       stdout=sp.PIPE, stderr=sp.PIPE, universal_newlines=True)
       proc.wait()

       # If exists switch to branch
       if proc.returncode == 128:
           print(f'Branch "{args.branch}" already exists')
           proc = sp.Popen(['git', 'switch', args.branch],
                           stdout=sp.PIPE, stderr=sp.PIPE, universal_newlines=True)
           proc.wait()
       # Set local branch name
       local_git_branch = args.branch

   # Commit changes before pull
   if args.commit != "":
       # Modify to add specific files
       proc = sp.Popen(['git', 'add', '.'], stdout=sp.PIPE,
                       stderr=sp.PIPE, universal_newlines=True)
       proc.wait()

       # Commit
       proc = sp.Popen(['git', 'commit', '-m', args.commit],
                       stdout=sp.PIPE, stderr=sp.PIPE, universal_newlines=True)
       proc.wait()

       # Information message if nothing to commit
       if proc.returncode != 0:
           print(f'Nothing to commit, everything up to date')

   # Push our local branch to remote
   proc = sp.Popen(['git', 'push', '--set-upstream', 'origin', local_git_branch],
                   stdout=sp.PIPE, stderr=sp.PIPE, universal_newlines=True)
   proc.wait()

   # Exit if some push errors
   if proc.returncode != 0:
       print(
           f'Git error: "git push --set-upstream origin {local_git_branch}" return code {proc.returncode}')
       exit(proc.returncode)

   print(f'Local branch name is: "{local_git_branch}"')

   # Connect to github api
   git_api = Github(token)

   # Get repository
   remote_project_repo = git_api.get_repo(remote_project)

   # Try to create pull request
   try:
       pull_request = remote_project_repo.create_pull(
           title=f'Pull request from {local_git_branch} to master', body=args.message, head=local_git_branch, base="master")
   except GithubException as ex:
       if ex.status == 422:
           print(
               f'ERROR: Pull request from "{local_git_branch}" to "master" already exists')
       exit(ex.status)

   print(
       f'Pull request was created sucessful. Request number is #{pull_request.number}')
   ```

   p.s. Сначала начал использовать модуль `PyGithub`, затем понял что в рамках данной задачи толку от него не много и все можно было сделать через бональный `curl`, но переписывать уже не стал

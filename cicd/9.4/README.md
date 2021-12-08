# Домашнее задание к занятию "9.4 Jenkins"

- [Jenkinsfile](Jenkinsfile) для тестирования роли `Elasticsearch`
  
    ```groovy
    pipeline {
        agent {
            label "linux"
        }
        stages {
            stage("Checkout repository") {
                steps {
                    git branch: 'main', url: 'https://github.com/develtime/galaxy.git'
                }
            }
            stage("Prepare requirement") {
                steps {
                    dir('develtime/services/roles/elasticsearch/') {
                        sh 'pip3 install -r requirements.txt'    
                    }
                    dir('develtime/services/roles/elasticsearch/molecule/default/files') {
                        writeFile file: 'README.md', text: '# Directory for downloadable files'
                    }
                    dir('develtime/services/roles/elasticsearch/molecule/light/files') {
                        writeFile file: 'README.md', text: '# Directory for downloadable files'
                    }
                }
            }
            stage("Molecule test") {
                steps {
                    dir('develtime/services/roles/elasticsearch/') {
                        sh 'molecule test -s light'    
                    }
                }
            }
        }
    }
    ```

- [Репозиторий](https://github.com/develtime/ansible/tree/main/8.4) с плейбуком разворачивающим `ELK`
- [ScriptedJenkinsfile](ScriptedJenkinsfile) для развертывания `ELK`

    ```groovy
    node("linux") {
        stage("Checkout") {
            git branch: 'main', credentialsId: 'a0e33387-dad9-43fd-a216-d27cc87aa9e9', url: 'git@github.com:develtime/ansible.git'
        }
        stage("Define playbook parameters") {
            common_args=''

            if(params.prodRun) {
                common_args='--check --diff'
            }

            print "DEBUG: parameter common_args = ${common_args}"
        }
        stage("Install requirements") {
            dir('8.4') {
                sh "ansible-galaxy collection install -r requirements.yml"    
            }
        }
        stage("Run playbook") {
            dir('8.4') {
                sh "ansible-playbook site.yml -i inventory/prod ${common_args}"
            }    
        }
    }
    ```

p.s. В задании путаная формулировка, не понятно в каком случае запускать с `--check --diff`, а в каком без, надеюсь это не принципиально.
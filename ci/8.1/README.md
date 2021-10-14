# Домашнее задание к занятию "8.1 Введение в Ansible"

## [Ansible playbook repository](https://github.com/develtime/ansible/tree/main/8.1)

1. `ansible-playbook site.yml -i inventory/test.yml`
   
   ![ansible_test](img/8_1_ansible_test.png)

2. [all default facts](https://github.com/develtime/ansible/blob/main/8.1/group_vars/all/example.yml#L2)
3. docker
   
   ![ansible_docker](img/8_1_ansible_docker.png)

4. `ansible-playbook site.yml -i inventory/prod.yml`
   
   ![ansible_prod](img/8_1_ansible_prod.png)

5. [deb default fact](https://github.com/develtime/ansible/blob/main/8.1/group_vars/deb/example.yml#L2) и [el default fact](https://github.com/develtime/ansible/blob/main/8.1/group_vars/el/example.yml#L2)

6. `ansible-playbook site.yml -i inventory/prod.yml`
   
   ![ansible_prod_2](img/8_1_ansible_prod_2.png)

7. Шифрование фактов
   
   ![ansible_vault](img/8_1_ansible_vault.png)

8. `ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass`
   
   ![ansible_prod_3](img/8_1_ansible_prod_3.png)

9. `local     execute on controller`
10. [prod local](https://github.com/develtime/ansible/blob/main/8.1/inventory/prod.yml#L11)
11. `ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass`
    
    ![ansible_prod_4](img/8_1_ansible_prod_4.png)
12. [playbook](https://github.com/develtime/ansible/tree/main/8.1)
# Домашнее задание к занятию "3.5. Файловые системы"

###

2. Нет, не могут, это просто файлы ссылающиеся на один и тот же inode на файловой системе.

3. Создана VM с дополнительными дисками из конфигурационного файла Vagrantfile<br />
 ![vm](img/disk_1.png)

4. Разбиение диска<br />
 ![fdisk1](img/fdisk_2.png)

5. Перенос таблицы разделов
 ![sfdisk](img/sfdisk_3.png)
 ![fdisk2](img/fdisk_4.png)

6. Сборка RAID1
7. Сборка RAID0<br />
 ![mdadm](img/mdadm_5.png)
 ![lsblk](img/lsblk_6.png)

8. Создание Physical Volumes<br />
 ![pvcreate](img/pvcreate_7.png)

9. Создание Volume Groups<br />
 ![vgcreate](img/vgcreate_8.png)

10. Создание Logical Volume размером 100 Мб<br />
 ![lvcreate](img/lvcreate_9.png)

11. Создание файловой системы EXT4<br />
 ![ext4](img/mkfs_10.png)

12. Монтирование раздела в директорию `mount /dev/vg_develtime/develtime0 /tmp/new`, либо при помощи редактирования `/etc/fstab`

13. Тестовый файл<br />
 ![lsal](img/file_11.png)

14. Вывод `lsblk`<br />
 ![lsblk2](img/lsblk_file_12.png)

15. Целостность файла<br />
 ![gzip1](img/gzip_13.png)

16. Перемещение содержимого PV с RAID0 на RAID1<br />
 ![pvmove](img/pvmove_14.png)
 ![lsblk3](img/lsblk_pvmove_15.png)

17. `mdadm --fail /dev/md0`

18. Вывод `dmesg`<br />
 ![dmesg](img/dmesg_16.png)

19. Целостность файла<br />
 ![gzip2](img/gzip_16.png)

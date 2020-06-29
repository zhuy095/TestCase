#!/bin/bash
# 1.use ssh-keygen commend create SSH Keys
# 2.put 'public key' write in github 'Settings' > 'SSH and GPG Keys'
# 3.run commend : git clone git@github.com:zhuy095/TestCase.git
# 4.run commend : cd TestCase
# 5.run commend : git config --global user.name "yongliang095"
# 6.run commend : git config --global user.email "yongliang095@qq.com"
# 7.add current scripting to crontab
#   0 2 * * *  /root/TestCase/TestlinkBackup.sh
#
# recover
# tar xvfz testlink_back_*.tar.gz
# mysql -u root -psunyainfo testlink < testlinkbackup.sql
# cp -f nodes_hierarchy  /var/www/testlink/upload_area/

BACKDIR=/root/backup/
BACKFILE="testlink_back_`date +20%y%m%d%H%M`.tar.gz"
TARDIR=/root/TestCase/
rm -fr $BACKDIR && mkdir -p $BACKDIR
mysqldump -u root -psunyainfo testlink > $BACKDIR/testlinkbackup.sql
cp -R /var/www/testlink/upload_area/nodes_hierarchy $BACKDIR
cd ~
tar cvfz $BACKFILE $BACKDIR
mv $BACKFILE $TARDIR
cd $TARDIR
git add $BACKFILE
git commit -m "backup `date +20%y%m%d%H%M`"
git commit -a
git push origin

echo "start delete old backup file"

if [[ `find ${TARDIR}*tar.gz -mtime +5 | xargs | wc -w` -ne 0 && `ls  *.tar.gz | xargs | wc -w` -gt 5 ]]
then
	for rmfile in `find *tar.gz -mtime +5 | xargs`
	do
		git rm $rmfile
		git commit -m "delete 5 days ago backup file $rmfile"
		git commit -a
	done
	git push origin
fi

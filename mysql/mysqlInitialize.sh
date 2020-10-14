#!/bin/sh

oldSqlPwd2=`/usr/local/mysql/bin/mysqld --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --initialize 2>&1 | grep -oP 'root@localhost:(.*)'`;
if [ "${oldSqlPwd2}" != "" ];then
oldSqlPwd3="${oldSqlPwd2:15:100}";
oldSqlPwd=`echo $oldSqlPwd3 | awk '{sub(/^ */, "")}1'`;
#��ʼ��������
echo $oldSqlPwd > onePwd.txt;
fi

/etc/init.d/mysqld start

if [ "${oldSqlPwd2}" != "" ];then
#��ȡ���ص�ַ������������dockerʹ�õ�IP��
gatewayIp=`ifconfig | grep inet | awk '{if($2 !~ /^(127.0.0.1)/)print $2}' | awk -F. '{print $1"."$2"."$3"."1}'`;
#����mysql���̺��޸�����
PASSWORD=`cat /onePwd.txt`
DBNAME="mysql"
sshpass -p ${PASSWORD} /usr/local/mysql/bin/mysql --connect-expired-password  -uroot -p ${DBNAME} <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQLPASSWORD}';
grant all privileges on *.* to root@"${gatewayIp}" identified by "${MYSQLPASSWORD}";
EOF
fi
#mysql.pid���첽����ģ��ȴ�mysqld.pid�ļ�������
sleep 2;
touch /usr/local/mysql/tailFile
mysqlId=`cat /usr/local/mysql/mysqld.pid`;
tail -f /usr/local/mysql/tailFile --pid=$mysqlId -s 2
#������Դ������ŷ��ͽ��м�أ���֪mysql���̶��ˣ�����ֱ������д���ŷ��ͽű�������ֱ��curl��������Ķ����߼�





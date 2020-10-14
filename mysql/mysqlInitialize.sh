#!/bin/sh

oldSqlPwd2=`/usr/local/mysql/bin/mysqld --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --initialize 2>&1 | grep -oP 'root@localhost:(.*)'`;
if [ "${oldSqlPwd2}" != "" ];then
oldSqlPwd3="${oldSqlPwd2:15:100}";
oldSqlPwd=`echo $oldSqlPwd3 | awk '{sub(/^ */, "")}1'`;
#初始化的密码
echo $oldSqlPwd > onePwd.txt;
fi

/etc/init.d/mysqld start

if [ "${oldSqlPwd2}" != "" ];then
#获取网关地址（宿主机访问docker使用的IP）
gatewayIp=`ifconfig | grep inet | awk '{if($2 !~ /^(127.0.0.1)/)print $2}' | awk -F. '{print $1"."$2"."$3"."1}'`;
#启动mysql进程后修改密码
PASSWORD=`cat /onePwd.txt`
DBNAME="mysql"
sshpass -p ${PASSWORD} /usr/local/mysql/bin/mysql --connect-expired-password  -uroot -p ${DBNAME} <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQLPASSWORD}';
grant all privileges on *.* to root@"${gatewayIp}" identified by "${MYSQLPASSWORD}";
EOF
fi
#mysql.pid是异步生存的，等待mysqld.pid文件的生成
sleep 2;
touch /usr/local/mysql/tailFile
mysqlId=`cat /usr/local/mysql/mysqld.pid`;
tail -f /usr/local/mysql/tailFile --pid=$mysqlId -s 2
#这里可以触发短信发送进行监控，告知mysql进程断了，但不直接在这写短信发送脚本，可以直接curl，方便更改短信逻辑





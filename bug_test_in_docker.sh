#!/bin/bash
if [ $( file mysqldump/dump_bug_consistent_read.bz2 2>/dev/null | grep -c bzip2 ) -eq 0 -o $( file mysqldump/dump_bug_consistent_read_feed.bz2 2>/dev/null | grep -c bzip2 ) -eq 0 ]
then
	git lfs	pull
        exit 1
fi
echo
#
SOME_MYSQL="mysql/mysql-server:8.0.19-1.1.15=mysql_8_0_19  mysql/mysql-server:8.0.4-1.1.3=mysql_8_0_4 mysql/mysql-server:8.0.1-1.0.0=mysql_8_0_1 mysql/mysql-server:5.7.29-1.1.15=mysql_5_7_29 mysql/mysql-server:5.6.47-1.1.15=mysql_5_6_47 mysql/mysql-server:5.6.36=mysql_5_6_36  mysql/mysql-server:5.6.35=mysql_5_6_35 mysql/mysql-server:5.6.23=mysql_5_6_23 mysql/mysql-server:5.5.62-1.1.10=mysql_5_5_62"
SOME_MARIA="mariadb:10.4.12=maria_10_4_12 mariadb:10.3.22=maria_10_3_22 mariadb:10.2.31=maria_10_2_31 mariadb:10.1.44=maria_10_1_44 mariadb:10.1.22=maria_10_1_22 mariadb:10.1.11=maria_10_1_11 mariadb:5.5.64=maria_5_5_64"
SOME_PERCO="percona:ps-8.0.18-9=perco_8_0_18 percona/percona-server:8.0.13=perco_8_0_13 percona:ps-5.7.29=perco_5_7_29 percona:ps-5.6.47=perco_5_6_47 percona:5.6.36=perco_5_6_36 percona:5.6.35=perco_5_6_35 percona:5.5.61=perco_5_5_61"
#
BUG_KO="mysql/mysql-server:5.6.35=mysql_5_6_35 mysql/mysql-server:5.7.17=mysql_5_7_17 percona:5.6.35=perco_5_6_35 percona:5.7.17=perco_5_7_17"
BUG_OK="mysql/mysql-server:5.6.36=mysql_5_6_36 mysql/mysql-server:5.7.18=mysql_5_7_18 percona:5.6.36=perco_5_6_36 percona:5.7.18=perco_5_7_18 mysql/mysql-server:5.7.29-1.1.15=mysql_5_7_29 percona:ps-5.7.29=perco_5_7_29"
#
PARA_CNT=4
C=0
for V in $BUG_KO $BUG_OK
do
        C=$(( $C + 1 ))
	(
                IMG=$( echo "$V"| cut -d= -f1)
                NAM=$( echo "$V"| cut -d= -f2)
                echo $IMG
                echo $NAM

                docker run --name ${NAM} -e MYSQL_ROOT_PASSWORD=test1234 -d ${IMG} || exit 1
		T=30
                while [ $( docker exec -i $NAM  mysqladmin -h localhost -u root -ptest1234 ping 2>&1 | grep -c 'mysqld is alive' ) -eq 0 -a $T -gt 0 ]
                do
                    sleep 2
		    T=$(( $T - 1 ))
                done
                docker exec -i $NAM  sh -c '/usr/bin/mysql  -u root -ptest1234  -h localhost -e "create database test ; " '

		FILTERCMD="sed 's/timestamp(6) NULL DEFAULT NULL/timestamp NULL DEFAULT NULL/' "
		( bzcat mysqldump/dump_bug_consistent_read.bz2                    | eval ${FILTERCMD}     | docker exec -i $NAM  sh -c '/usr/bin/mysql  -u root -ptest1234  -h localhost test ' ) &
		( bzcat mysqldump/dump_bug_consistent_read_feed.bz2               | eval ${FILTERCMD}     | docker exec -i $NAM  sh -c '/usr/bin/mysql  -u root -ptest1234  -h localhost test ' ) &

                wait
                for F in bug_create_buggy.sql bug_buggy_chunks.sql bug_session_a.sql bug_session_b.sql
                do
                  cat $F | docker exec -i ${NAM} sh -c "dd of=/tmp/$F"
                done
                docker exec -i $NAM  sh -c 'cd /tmp; /usr/bin/mysql  -u root -ptest1234  -h localhost test -e "source bug_session_a.sql"' > /tmp/output_${NAM}_session_a.log 2>&1 &
                docker exec -i $NAM  sh -c 'cd /tmp; /usr/bin/mysql  -u root -ptest1234  -h localhost test -e "source bug_session_b.sql"' > /tmp/output_${NAM}_session_b.log 2>&1 &
                wait
                docker stop ${NAM}
                docker rm --volumes ${NAM}
	) &
       if [ $(( $C  % $PARA_CNT )) = 0 ]
       then
           wait
       fi
done
wait
echo version that are buggy
grep -l -e '_20000_.*: [1]' -e '_10000_.*: [2-9]' -e '_15000_.*: 1[0-4]' -e '_5000_.*: [0-4]'  /tmp/output_*log  | sort -t_ -k3,5




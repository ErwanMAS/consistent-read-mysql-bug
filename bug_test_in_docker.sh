#!/bin/bash
if [ $( file mysqldump/dump_bug_consistent_read.bz2 2>/dev/null | grep -c bzip2 ) -c 0 -o $( file mysqldump/dump_bug_consistent_read_feed.bz2 2>/dev/null | grep -c bzip2 ) ]
then
	git lfs	pull
        exit 1
fi
echo
for V in mysql/mysql-server:8.0.19-1.1.15=mysql_8_0_19  mysql/mysql-server:5.7.29-1.1.15=mysql_5_7_29 mysql/mysql-server:5.6.47-1.1.15=mysql_5_6_47 mysql/mysql-server:5.5.62-1.1.10=mysql_5_5_62 \
       	 mariadb:10.4.12=maria_10_4_12 mariadb:10.3.22=maria_10_3_22 mariadb:10.2.31=maria_10_2_31 mariadb:10.1.44=maria_10_1_44 mariadb:5.5.64=maria_5_5_64 \
         percona:ps-5.7.29=perco_5_7_29 percona:ps-5.6.47=perco_5_6_47 percona:ps-8.0.18-9=perco_8_0_18 percona:5.5.61=perco_5_5_61
do
        IMG=$( echo "$V"| cut -d= -f1)
        NAM=$( echo "$V"| cut -d= -f2)
	(
                echo $IMG
                echo $NAM

                docker run --name ${NAM} -e MYSQL_ROOT_PASSWORD=test1234 -d ${IMG} || exit 1
                while [ $( docker exec -i $NAM  mysqladmin -h localhost -u root -ptest1234 ping 2>&1 | grep -c 'mysqld is alive' ) -eq 0 ]
                do
                        sleep 2
                done
                docker exec -it $NAM  sh -c '/usr/bin/mysql  -u root -ptest1234  -h localhost -e "create database test ; " '

                ( bzcat mysqldump/dump_bug_consistent_read.bz2                          | docker exec -i $NAM  sh -c '/usr/bin/mysql  -u root -ptest1234  -h localhost test ' ) &
                ( bzcat mysqldump/dump_bug_consistent_read_feed.bz2                     | docker exec -i $NAM  sh -c '/usr/bin/mysql  -u root -ptest1234  -h localhost test ' ) &
                wait
                for F in bug_create_buggy.sql bug_buggy_chunks.sql bug_session_a.sql bug_session_b.sql
                do
                  cat $F | docker exec -i ${NAM} sh -c "dd of=/tmp/$F"
                done

                docker exec -i $NAM  sh -c '/usr/bin/mysql  -u root -ptest1234  -h localhost test -e "source /tmp/bug_session_a.sql"' > /tmp/output_${NAM}_session_a.log 2>&1 &
                docker exec -i $NAM  sh -c '/usr/bin/mysql  -u root -ptest1234  -h localhost test -e "source /tmp/bug_session_b.sql"' > /tmp/output_${NAM}_session_b.log 2>&1 &
                wait
                docker stop ${NAM}
                docker rm   ${NAM}
      )
done
echo version that are buggy
grep -l -e '_20000_.*: [1]' -e '_10000_.*: [2-9]' -e '_15000_.*: 1[0-4]' -e '_5000_.*: [0-4]'  /tmp/output_*log




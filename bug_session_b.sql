delimiter //
system while [ ! -f /tmp/consistent_session_created  ] ; do sleep 2 ; done ;  //
delimiter ;
select NOW() as currenttime ,'wait for A  is done' as msg \G
source /tmp/bug_create_buggy.sql;
select NOW() as currenttime ,'insert extra row is done' as msg \G
system touch /tmp/buggy_chunk_created ;


START TRANSACTION WITH CONSISTENT SNAPSHOT ;
source /tmp/bug_buggy_chunks.sql ;
select NOW();
select count(*) from test.bug_consistent_read ;
select count(*) from test.bug_consistent_read_feed ;
select NOW() as currenttime ,'Count is done' as msg \G
system touch /tmp/consistent_session_created ;
delimiter //
system while [ ! -f /tmp/buggy_chunk_created  ] ; do sleep 2 ; done ;  //
delimiter ;
select NOW() as currenttime ,'wait for B  is done' as msg \G
source /tmp/bug_buggy_chunks.sql ;

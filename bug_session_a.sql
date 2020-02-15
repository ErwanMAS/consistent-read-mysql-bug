START TRANSACTION WITH CONSISTENT SNAPSHOT ;
source /tmp/bug_buggy_chunks.sql ;
select NOW();
select count(*) from test.bug_consistent_read ;
select count(*) from test.bug_consistent_read_feed ;
delimiter //
system while [ ! -f /tmp/buggy_chunk_created  ] ; do sleep 2 ; done ;  //
delimiter ;
select NOW();
source /tmp/bug_buggy_chunks.sql ;

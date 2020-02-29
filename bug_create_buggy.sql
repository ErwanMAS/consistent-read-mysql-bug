insert into test.bug_consistent_read select * from ( select e.* from test.bug_consistent_read_feed e left join test.bug_consistent_read c  on c.clientid=e.clientid and c.ticketid=e.ticketid where c.clientid is null and c.ticketid is null limit 22000 ) f ;



insert into test.bug_consistent_read select * from ( select e.* from test.bug_consistent_read_feed e left join test.bug_consistent_read c  on c.clientid=e.clientid and c.ticketid=e.ticketid where c.clientid is null and c.ticketid is null limit 40000 ) f ;
insert into test.bug_consistent_read select * from ( select e.* from test.bug_consistent_read_feed e left join test.bug_consistent_read c  on c.clientid=e.clientid and c.ticketid=e.ticketid where c.clientid is null and c.ticketid is null limit 40000 ) f ;
insert into test.bug_consistent_read select * from ( select e.* from test.bug_consistent_read_feed e left join test.bug_consistent_read c  on c.clientid=e.clientid and c.ticketid=e.ticketid where c.clientid is null and c.ticketid is null limit 40000 ) f ;
insert into test.bug_consistent_read select * from ( select e.* from test.bug_consistent_read_feed e left join test.bug_consistent_read c  on c.clientid=e.clientid and c.ticketid=e.ticketid where c.clientid is null and c.ticketid is null limit 40000 ) f ;



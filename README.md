#  consistent-read-mysql-bug

This is a dataset to demonstrate a very serious bug with `START TRANSACTION WITH CONSISTENT SNAPSHOT ;`

With this bug data can disappear . 

this regression appear between version version 5.6.35 and version 5.6.36 and 5.6.47 has still the bug 

this regression appear between version version 5.7.17 and version 5.7.18 and 5.7.29 has still the bug

ps: 
 
https://jira.percona.com/browse/PS-6855


## populate 2 tables with 2 mysql dumps

```
bzcat dump_bug_consistent_read.bz2       | mysql test
bzcat dump_bug_consistent_read_feed.bz2  | mysql test
```

## full automated tests  with the 2 helper scripts


open a session A and source `bug_session_a.sql`

open a session B and source `bug_session_b.sql`

both scripts will use /tmp/ for	creating files to sync .


## manual process step by step 

1. open a session A

`source bug_buggy_chunks.sql ; `

must return always a rounded number ( 2000 , 5000 , 10000 , 15000 , 20000 ) 

2. open a session B

start a consistent snapshot with

`START TRANSACTION WITH CONSISTENT SNAPSHOT ;`

`source bug_buggy_chunks.sql ; `

must return always a rounded number ( 2000 , 5000 , 10000 , 15000 , 20000 ) 


3. now back on session A

source file `bug_create_buggy.sql`

this file will pouplate `bug_consistent_read` with some row of `bug_consistent_read_feed`

when is done

4. back to session B

run again the script and you will see many values not rounded  

`source bug_buggy_chunks.sql ; `


# perco-mysql-bug

you NEED to use `git lfs clone https://github.com/ErwanMAS/perco-mysql-bug.git`

git lfs is for large objects ( in this repo , mysqldump/ )


populate 2 tables with the 2 dumps

```
bzcat dump_bug_consistent_read.bz2       | mysql test
bzcat dump_bug_consistent_read_feed.bz2  | mysql test
```


open a session A

`source bug_buggy_chunks.sql ; `

must return always 10000


open a session B

start a consistent snapshot with

`START TRANSACTION WITH CONSISTENT SNAPSHOT ;`

check we have 10000 for every query

`source bug_buggy_chunks.sql ; `


now back on session A

source file `bug_create_buggy.sql`

this file will pouplate `bug_consistent_read` with some row of `bug_consistent_read_feed`

when is done

back to session B

run again the script and you will see values differents of 10000 

`source bug_buggy_chunks.sql ; `

BINGO BUG




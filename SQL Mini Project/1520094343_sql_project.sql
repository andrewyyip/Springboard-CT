/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

select
name
from country_club.Facilities fac
where fac.membercost > 0
group by name



/* Q2: How many facilities do not charge a fee to members? */

select 
count(distinct name) as "# of free facilities"
from country_club.Facilities
where membercost = 0



/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

select
facid,
name,
membercost,
monthlymaintenance
from country_club.Facilities
where membercost < (0.2 * monthlymaintenance)



/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

select *
from country_club.Facilities
where facid in (1,5)



/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

select 
name,
monthlymaintenance,
case when monthlymaintenance > 100 then 'expensive' else 'cheap' end as cost
from country_club.Facilities



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

select
firstname,
surname
from country_club.Members
where joindate =(select max(joindate) from country_club.Members)



/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

select
fac.name as facility,
concat(mem.surname, ', ', mem.firstname) as member_name

from country_club.Bookings as book

left join country_club.Facilities as fac
on book.facid = fac.facid

left join country_club.Members as mem
on book.memid = mem.memid

where book.facid in (0,1) and book.memid >0

group by 2
order by member_name



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

select
fac.name as facility,
concat (mem.surname, ', ', mem.firstname) as member_name,
case when mem.memid = 0 then fac.guestcost*book.slots else fac.membercost*book.slots end as cost

from country_club.Bookings as book
left join country_club.Facilities as fac
on book.facid = fac.facid

left join country_club.Members as mem
on book.memid = mem.memid

where left(book.starttime, 10) = '2012-09-14' 

having cost > 30
order by cost desc



/* Q9: This time, produce the same result as in Q8, but using a subquery. */


select sub.*

from 
(
select
fac.name as facility,
concat (mem.surname, ', ', mem.firstname) as member_name,
case when mem.memid = 0 then fac.guestcost*book.slots else fac.membercost*book.slots end as cost

from country_club.Bookings as book
left join country_club.Facilities as fac
on book.facid = fac.facid

left join country_club.Members as mem
on book.memid = mem.memid

where left(book.starttime, 10) = '2012-09-14' 

order by cost desc
) sub

where cost > 30



/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

select sub.*
from
(
select 
fac.name as name,
sum(case when book.memid = 0 then fac.guestcost*book.slots else fac.membercost*book.slots end) as cost
from country_club.Bookings as book
left join country_club.Facilities as fac
on book.facid = fac.facid
group by name
order by cost desc
) sub

where cost<=1000


-- show the user_name of the users who use djuice package and
-- have used al least 1000 taka in the past 60 days
-- using only queries

select user_name, mobile_number from users u
where package_id  = (select package_id
                     from package where package_name = 'DJUICE'
) and (
    (coalesce((select sum(cost) from call_history
               where user_id = u.mobile_number and now()-h_date <=
                                                   interval '1 day' * 60),0)+
     coalesce((select sum(cost) from sms_history where user_id = u.mobile_number
                                                   and now() - h_date <= interval '1 day' * 60),0)+
     coalesce((select sum(s.price) from purchase_offer o join sms_offer s on o.offer_id = s.offer_id
               where o.user_id = u.mobile_number and now()- purchase_date <= interval '1 day' * 60), 0) +
     coalesce((
                select sum(i.price) from purchase_offer o join internet_offer i on o.offer_id = i.offer_id
                where o.user_id = u.mobile_number and now()- purchase_date <= interval '1 day' * 60), 0) +
     coalesce((
                select sum(t.price) from purchase_offer o join talk_time_offer t on o.offer_id = t.offer_id
                where o.user_id = u.mobile_number and now()- purchase_date <= interval '1 day' * 60), 0)+
     coalesce((
                select sum(g.price) from purchase_offer o join general_offer g on o.offer_id = g.offer_id
                where o.user_id = u.mobile_number and now()- purchase_date <= interval '1 day' * 60), 0)) >= 1000
  );

--using function
select user_name from users u
where package_id  = (select package_id
                     from package where package_name = 'DJUICE'
) and (count_used_amount(u.mobile_number, 60) >= 1000);

create or replace function count_used_amount(in mob numeric, in days int)
  returns numeric  as $$
declare
  amount numeric;
  call_h cursor for select * from call_history where user_id = mob
                                                 and now()- h_date <= interval '1 day' * days;
  sms_h cursor for select * from sms_history where user_id = mob
                                               and now()- h_date <= interval '1 day' * days;
  pur_offer cursor for select * from purchase_offer where user_id = mob
                                                      and now()- purchase_date <= interval '1 day' * days;
  temp_cost numeric;

begin
  amount := 0;
  for r in call_h
    loop
      amount := amount + r.cost;
    end loop;
  for r in sms_h
    loop
      amount := amount + r.cost;
    end loop;
  for r in pur_offer
    loop
      temp_cost := 0;
      if r.offer_id in  (select offer_id from internet_offer) then
        select price from internet_offer where offer_id = r.offer_id into temp_cost;
      elseif r.offer_id in  (select offer_id from talk_time_offer) then
        select price from talk_time_offer where offer_id = r.offer_id into temp_cost;
      elseif r.offer_id in  (select offer_id from sms_offer) then
        select price from sms_offer where offer_id = r.offer_id into temp_cost;
      end if;
      amount := amount + temp_cost;
    end loop;
  return amount;
end;
$$ language  plpgsql;


-- show the user_name and total number of sms he or she
-- has sent in the past 90 days, of the users who have used
-- an offer more than or equal 3 times in the past 60 days


-- using only queries
select user_name, (
  coalesce((select count(*)
            from sms_history where
                user_id = u.mobile_number and now() - h_date <= interval  '1 day' * 90
                               and type = 'outgoing'), 0)) sms_sent
from users u
where 3 <= (coalesce((select max(tab.max_count) from (select count(*) max_count from purchase_offer where user_id = u.mobile_number
                                                                                                      and now() - purchase_date <= interval '1 day' * 60
                                                      group by offer_id) tab),0));

-- using a function
select user_name, (
  coalesce((select count(*)
            from sms_history where
                user_id = u.mobile_number and now() - h_date <= interval  '1 day' * 90
                               and type = 'outgoing'), 0)) sms_sent
from users u
where 3 <= max_same_offer_used(u.mobile_number, 60);

create or replace function max_same_offer_used(in mob numeric, in days numeric)
  returns int as $$
declare
  max_count int;
  offer cursor for select count(user_id) tcount
                   from purchase_offer where user_id = mob and
                         now() - purchase_date <= interval '1 day' * days
                   group by offer_id;
begin
  max_count := 0;
  for r in offer
    loop
      if max_count < r.tcount then
        max_count := r.tcount;
      end if;
    end loop;
  return max_count;
end;
$$ language plpgsql;


-- show the users name and star status, who have taken the offer
-- that have been purchased maximum number of times

select user_name, mobile_number, (
  select type
  from star
  where star_id = u.star_id
) star_status
from users u  where mobile_number in ( select max_users_table.uss from
  (select distinct user_id uss
   from purchase_offer
   where offer_id = (select max_table.offer_id
                     from (
                            select offer_id, count(purchase_offer.offer_id) cc
                            from purchase_offer
                            group by offer_id
                            order by cc desc
                              fetch first row only
                          ) max_table)
  ) max_users_table);


-- Show the user name and the total used amount in the last month, who are PLATINUM PLUS
-- users and fnf of at least 2 users and linked by at least two users

select user_name, (
  select (coalesce((select sum(cost) from call_history where user_id = u.mobile_number
                                                         and now()-h_date <= interval '1 day' * 60),0)+
          coalesce((select sum(cost) from sms_history where user_id = u.mobile_number
                                                        and now() - h_date <= interval '1 day' * 30),0)+
          coalesce((select sum(s.price) from purchase_offer o join sms_offer s on o.offer_id = s.offer_id
                    where o.user_id = u.mobile_number and now()- purchase_date <= interval '1 day' * 30), 0) +
          coalesce((select sum(i.price) from purchase_offer o join internet_offer i on o.offer_id = i.offer_id
                    where o.user_id = u.mobile_number and now()- purchase_date <= interval '1 day' * 30), 0) +
          coalesce(( select sum(t.price) from purchase_offer o join talk_time_offer t on o.offer_id = t.offer_id
                     where o.user_id = u.mobile_number and now()- purchase_date <= interval '1 day' * 30), 0)+
          coalesce((select sum(g.price) from purchase_offer o join general_offer g on o.offer_id = g.offer_id
                    where o.user_id = u.mobile_number and now()- purchase_date <= interval '1 day' * 30), 0))
) total_used_amount
from users u
where u.star_id = (
  select star_id from star
  where type = 'PLATINUM_PLUS'
) and 2 <= (
  coalesce((select count(*) from fnf where fnf_to = u.mobile_number), 0)
  ) and 2 <= (
  coalesce((select count(*) from link where linked_to = u.mobile_number),0));


-- find the offer_id and price of top five all kinds of offers those have been purchased in last 3 months

select offer_id , price, (select count(*) from purchase_offer where offer_id = io.offer_id) purchase_count from internet_offer io
where io.offer_id in
      (select offer_id
       from (select offer_id,
                    (select count(*) from purchase_offer
                     where offer_id = o.offer_id and (now()-purchase_date) < interval '1 day'*90 ) cnt
             from offers o
             group by o.offer_id
             order by cnt desc fetch first 5 row only) first_five
      )
union
select offer_id , price, (select count(*) from purchase_offer where offer_id = sm.offer_id) purchase_count  from sms_offer sm
where sm.offer_id in
      (select offer_id
       from (select offer_id,
                    (select count(*) from purchase_offer
                     where offer_id = o.offer_id and (now()-purchase_date) < interval '1 day'*90 ) cnt
             from offers o
             group by o.offer_id
             order by cnt desc fetch first 5 row only) first_five
      )
union
select offer_id , price, (select count(*) from purchase_offer where offer_id = tm.offer_id) purchase_count  from talk_time_offer tm
where tm.offer_id in
      (select offer_id
       from (select offer_id,
                    (select count(*) from purchase_offer
                     where offer_id = o.offer_id and (now()-purchase_date) < interval '1 day'*90 ) cnt
             from offers o
             group by o.offer_id
             order by cnt desc fetch first 5 row only) first_five
      )
union
select offer_id , price, (select count(*) from purchase_offer where offer_id = go.offer_id) purchase_count  from general_offer go
where go.offer_id in
      (select offer_id
       from (select offer_id,
                    (select count(*) from purchase_offer
                     where offer_id = o.offer_id and (now()-purchase_date) < interval '1 day'*90 ) cnt
             from offers o
             group by o.offer_id
             order by cnt desc fetch first 5 row only) first_five
      )
union
select offer_id , price, (select count(*) from purchase_offer where offer_id = ro.offer_id) purchase_count  from reward_offer ro
where ro.offer_id in
      (select offer_id
       from (select offer_id,
                    (select count(*) from purchase_offer
                     where offer_id = o.offer_id and (now()-purchase_date) < interval '1 day'*90 ) cnt
             from offers o
             group by o.offer_id
             order by cnt desc fetch first 5 row only) first_five
      )
order by purchase_count desc ;

-- give the user number of internet offer, sms offer, talk-time offers count
-- purchased by each star type in last 2 months

select str.type ,
       (select count(*)
        from purchase_offer
        where offer_id >= 12000
          and offer_id < 13000
          and user_id in (
          select mobile_number
          from users
          where star_id = (
            select star_id
            from star
            where type = str.type
          )
        ) and (now()-purchase_date) < interval '1 day'*60
       ) total_internet_offer,
       (select count(*)
        from purchase_offer
        where offer_id >= 11000
          and offer_id < 12000
          and user_id in (
          select mobile_number
          from users
          where star_id = (
            select star_id
            from star
            where type = str.type
          )
        ) and (now()-purchase_date) < interval '1 day'*60
       ) total_talk_time_offer,
       (select count(*)
        from purchase_offer
        where offer_id >= 10000
          and offer_id < 11000
          and user_id in (
          select mobile_number
          from users
          where star_id = (
            select star_id
            from star
            where type = str.type
          )
        ) and (now()-purchase_date) < interval '1 day'*60
       ) total_sms_offer
from star str;

-- find the users who have made at least 1 call to its current fnf numbers in
-- last 6 months along with the fnf numbers to which they called and number of
-- calls made

select fn.fnf_by,  fn.fnf_to,
       (select count(*)
        from call_history
        where user_id = fn.fnf_by
          and type = 'outgoing'
          and (now() - h_date) < interval '1 day'*180
          and call_number in (
          select fnf_to
          from fnf
          where fnf_by = fn.fnf_by
        )
       )
from fnf fn
where 1<=(select count(*)
          from call_history
          where user_id = fn.fnf_by
            and type = 'outgoing'
            and (now() - h_date) < interval '1 day'*180
            and call_number in (
            select fnf_to
            from fnf
            where fnf_by = fn.fnf_by
          )
);

-- those users who are under the bondhu package and a star, give their star
-- status, total count of the call list and total sms
-- made  of last 3 months

select mobile_number, user_name ,
       (select type from star where star_id = us.star_id) star_status,
       (select count(*) from call_history ch
        where ch.user_id = us.mobile_number and (now() - h_date) < interval '1 day'*90) total_call_made,
       (select count(*) from sms_history sh
        where sh.user_id = us.mobile_number and (now() - h_date) < interval '1 day'*90) total_sms_made
from users us
where package_id = (
  select package_id from package
  where package_name = 'BONDHU'
) and star_id > 0;

-- how much

select sum(T.price)
from (
       (select o.offer_id, internet_offer.price
        from (select offer_id from purchase_offer where user_id = '01728607800') o
               inner join internet_offer on (o.offer_id = internet_offer.offer_id)
       )
       union all
       (select o.offer_id, talk_time_offer.price
        from (select offer_id from purchase_offer where user_id = '01728607800') o
               inner join talk_time_offer on (o.offer_id = talk_time_offer.offer_id)
       )
       union all
       (select o.offer_id, sms_offer.price
        from (select offer_id from purchase_offer where user_id = '01728607800') o
               inner join sms_offer on (o.offer_id = sms_offer.offer_id)
       )
       union all
       (select o.offer_id, general_offer.price
        from (select offer_id from purchase_offer where user_id = '01728607800') o
               inner join general_offer on (o.offer_id = general_offer.offer_id)
       )
     ) as T


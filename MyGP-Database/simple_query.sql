
--showing username, balance, total_data, total_talk_time, total_sms
select user_name, balance, total_mb, total_talk_time, total_offer_sms, total_reward_point,
       (select package_name from package where package_id = us.package_id) package_name,
       (select type from star where star_id = us.star_id) star_status
from users us
where mobile_number = 1719560267;

--showing call_history
select call_number, to_char(h_date, 'YYYY-MM-DD HH12:MI:SS PM') as date, cost, type
from call_history where user_id = 1745277803;

--showing sms_history
select sms_number, to_char(h_date, 'YYYY-MM-DD HH12:MI:SS PM') as date, cost, type
from sms_history where user_id = 1755840785;

--showing internet_history
select mb_used, to_char(h_date, 'YYYY-MM-DD HH12:MI:SS PM') as date
from internet_history where user_id = 1755840785;

--showing recharge_history
select amount, validity, to_char(h_date, 'YYYY-MM HH12:MI:SS PM') as recharged_time
from recharge_history where  user_id = 1755840785;

--showing reward_offer
select offer_id, mb_amount, points_need, validity
from reward_offer;

--showing talk_time_offer
select offer_id, talk_time, validity, price, reward_points
from talk_time_offer;

--showing sms_offer
select offer_id, sms_amount, validity, price, reward_points
from sms_offer;

--showing data_offer
select offer_id, data_amount, validity, price, reward_points
from internet_offer;

--showing packages
select package_name, call_rate, data_rate, fnf_limit
from package;

--showing notifications
select message from notifications
where user_id = 1762464967;

-- show the star offers of an user according to his star status

select offer_name, title, description, (select type from star where star_id = so.star_id) star_status
from stars_offer so
where star_id = (
  select star_id from users
  where mobile_number = 1769129133
);

--checking star status
select type from star where star_id = (
  select star_id from users
  where mobile_number = 01787571128 and star.star_id is not null
);

select offer_id from offers order by offer_id;

-- fkldfslkjsldk

select PRICE from internet_offer
where OFFER_ID in (
  select OFFER_ID from PURCHASE_OFFER
  where USER_ID = 01787571128 and (now() - PURCHASE_DATE) < interval '1 day' * 90
);



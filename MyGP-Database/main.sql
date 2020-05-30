create database mygp;

do  $$
  declare
    ccc varchar(40);
  begin
    /*ccc := count_used_amount(01730388368, 60);
    raise notice '%', ccc;*/
    if is_valid_number('01769466313') then
      raise notice 'It is a valid number';
    else raise notice 'It is not a valid mobile number';
    end if;
    --call purchase_reward_offer(1748533677, 13544);
    --select count_general_offer_price(30, 1000, 50, 30);
  end;
  $$;

select * from pg_timezone_names;

set timezone = 'asia/dhaka';
do $$
begin
raise notice 'the current month date and time is %',to_char((now()-interval '1 day' * 30), 'yyyy-mm-dd hh12:mi:ss pm');
end;
$$;


copy random_table to 'e:\dopbox\dropbox\level 2 term 2\database sessional\project mygp\new\mygp-database\timestamp.csv'
with (null  'minus',
delimiter ',');

create table random_table(
  random_time timestamptz
);
copy random_table from 'e:\dopbox\dropbox\level 2 term 2\database sessional\project mygp\new\mygp-database\timestamp.csv';

do $$
declare
count int;
begin
  count := 0;
  loop
    insert into random_table values (now() - interval '1 day' * random() * 180);
    count:= count + 1;
    if count = 50000 then
      exit;
    end if;
  end loop;
end;
$$;

select is_valid_number('01769466313');

select user_name, balance, total_mb, total_talk_time, total_offer_sms, total_reward_point,
       (select package_name from package where package_id = us.package_id) package_name,
       (select type from star where star_id = us.star_id) star_status
from users us
where mobile_number = '01728607800';

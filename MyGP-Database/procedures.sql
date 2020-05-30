create or replace function is_valid_number(in number varchar(11)) returns boolean as $$
declare
  count int;
  ret boolean;
begin
  ret = true;
  select count(*) from users where mobile_number = number into count;
  if count = 0 then
    ret = false;
  end if;
  return ret;

end;
$$ language plpgsql;


create or replace function is_valid_sms_offer(in offer_i numeric) returns boolean as $$
declare
  count int;
  ret boolean;
begin
  ret = true;
  select count(*) from sms_offer where  offer_id = offer_i into count;
  if count = 0 then
    ret = false;
  end if;
  return ret;

end;
$$ language plpgsql;

create or replace function is_valid_talk_time_offer(in offer_i numeric) returns boolean as $$
declare
  count int;
  ret boolean;
begin
  ret = true;
  select count(*) from talk_time_offer where  offer_id = offer_i into count;
  if count = 0 then
    ret = false;
  end if;
  return ret;

end;
$$ language plpgsql;

create or replace function is_valid_reward_offer(in offer_i numeric) returns boolean as $$
declare
  count int;
  ret boolean;
begin
  ret = true;
  select count(*) from reward_offer where  offer_id = offer_i into count;
  if count = 0 then
    ret = false;
  end if;
  return ret;

end;
$$ language plpgsql;

create or replace function is_valid_data_offer(in offer_i numeric) returns boolean as $$
declare
  count int;
  ret boolean;
begin
  ret = true;
  select count(*) from internet_offer where  offer_id = offer_i into count;
  if count = 0 then
    ret = false;
  end if;
  return ret;

end;
$$ language plpgsql;

create or replace function recharge_account(in mob_number varchar(11), in amount numeric) returns varchar(100) as $$
declare
  old_amount numeric;
  eb_due numeric;
  cur_timestamp timestamptz;
  validity numeric;
  end_date varchar(100);
  message varchar(100);
begin
  if not is_valid_number(mob_number) then
    return 'Mobile number is not valid';
  end if;
  select balance, emergency_balance_due into old_amount, eb_due from users where mobile_number = mob_number;
  cur_timestamp := now();
  validity := find_recharge_last_date(amount);
  end_date := to_char(cur_timestamp + interval '1 day' * validity, 'yyyy-mm-dd hh12:mi:ss am');
  insert into recharge_history values (cur_timestamp, mob_number, amount, validity);
  if eb_due > 0 then
    if amount > eb_due then
      amount := amount-eb_due;
      eb_due := 0;
    else
      eb_due := eb_due-amount;
      amount := 0;
    end if;
  end if;

  update users set (balance,emergency_balance_due) = (old_amount + amount, eb_due) where mobile_number = mob_number;
  insert into notifications
  values (mob_number, 'you have successfully recharged ' ||
                      amount || ' taka in your account balance. your current account balance is '
    || old_amount+ amount || ' taka. your balance will be expired on '|| end_date);
  message := 'Successfully recharged in the account! :D';
  return message;
  exception when others then
    message := 'Cannot recharge :(';
    return message;
end;
$$ language plpgsql;

create or replace function find_recharge_last_date(in amount numeric) returns numeric as $$
  declare
  valid_days numeric;
    begin
    if(amount < 50) then
      valid_days := 30;
    else valid_days := 60;
    end if;
    return valid_days;
  end;
  $$ language plpgsql;

create or replace function purchase_sms_offer(in offer_no numeric, in user_no varchar(11)) returns varchar(100) as $$
  declare
    purchased_timestamp timestamptz;
    cost numeric(8,2);
    end_date varchar(100);
    valid numeric;
    reward_point numeric;
    sms_total numeric;
    old_reward_point numeric;
    old_account_balance numeric;
    old_sms numeric;
    message varchar(100);
  begin
    if not is_valid_number(user_no) then
      return 'Mobile number is not valid';
    end if;
    if not is_valid_sms_offer(offer_no) then
      return 'SMS offer id is not valid';
    end if;
    purchased_timestamp := now();
    select price, validity, reward_points, sms_amount  from sms_offer where  offer_id = offer_no
    into cost, valid, reward_point, sms_total;
    select total_reward_point, balance, total_offer_sms from users where mobile_number = user_no
    into old_reward_point, old_account_balance, old_sms;
    if old_account_balance >= cost then
      end_date := to_char(purchased_timestamp + interval '1 day' * valid, 'yyyy-mm-dd hh12:mi:ss am');
      insert into purchase_offer values (user_no, offer_no,purchased_timestamp);
      insert into notifications values (user_no, 'you have successfully purchased '
      ||sms_total || '. '||cost || ' taka has been deducted from your account balance.'
      ||' the sms bundle will expire on '|| end_date);
      update users set(total_reward_point, total_offer_sms, balance) =
      (old_reward_point+reward_point, old_sms + sms_total, old_account_balance-cost)
      where mobile_number = user_no;
      message := 'Successfully purchased the sms offer! :D';
    else
    message := 'Have not sufficient balance :(';
    end if;
    return message;

    exception
    when others then
    message :=  'Cannot purchase the sms offer :(';
    return message;
  end;
  $$ language plpgsql;


create or replace function purchase_talk_time_offer(in offer_no numeric, in user_no varchar(11)) returns varchar(100) as $$
  declare
    purchased_timestamp timestamptz;
    cost numeric(8,2);
    end_date varchar(100);
    valid numeric;
    reward_point numeric;
    talk_time_total numeric;
    old_reward_point numeric;
    old_account_balance numeric;
    old_talk_time numeric;
    message varchar(100);
  begin
    if not is_valid_number(user_no) then
      return 'Mobile number is not valid';
    end if;
    if not is_valid_talk_time_offer(offer_no) then
      return 'Talk Time offer id is not valid';
    end if;
    purchased_timestamp := now();
    select price, validity, reward_points, talk_time  from talk_time_offer where  offer_id = offer_no
    into cost, valid, reward_point, talk_time_total;
    select total_reward_point, balance, total_talk_time from users where mobile_number = user_no
    into old_reward_point, old_account_balance, old_talk_time;
    if old_account_balance >= cost then
      end_date := to_char(purchased_timestamp + interval '1 day' * valid, 'yyyy-mm-dd hh12:mi:ss am');
      insert into purchase_offer values (user_no, offer_no,purchased_timestamp);
      insert into notifications values (user_no, 'you have successfully purchased '
      ||talk_time_total || ' minutes. '||cost || ' taka has been deducted from your account balance.'
      ||' the talk time bundle will expire on '|| end_date);
      update users set (total_reward_point, total_talk_time, balance) =
      (old_reward_point+reward_point, old_talk_time + talk_time_total, old_account_balance-cost)
      where mobile_number = user_no;
      message :=  'Successfully purchased the talk time offer! :D';
    else
      message := 'Have not sufficient balance :(';
    end if;
    return message;

    exception  when others then
    message := 'Cannot purchase the talk time offer :(';
    return message;
  end;
  $$ language plpgsql;


create or replace function purchase_general_offer
  (in user_no varchar(11), in min numeric, in data numeric, in sms numeric, in valid numeric) returns varchar(100)
as $$
  declare
    purchased_timestamp timestamptz;
    cost numeric(8,2);
    end_date varchar(100);
    old_account_balance numeric;
    old_talk_time numeric;
    old_data numeric;
    old_sms numeric;
    offer_no numeric;
    messsage varchar(100);
  begin
    if not is_valid_number(user_no) then
      return 'Mobile number is not valid';
    end if;
    purchased_timestamp := now();
    select balance, total_talk_time, total_mb, total_offer_sms from users where mobile_number = user_no into
    old_account_balance, old_talk_time, old_data, old_sms;
    cost := count_general_offer_price(sms, data, min, valid);

    if old_account_balance >= cost then
      end_date := to_char(purchased_timestamp + interval '1 day' * valid, 'yyyy-mm-dd hh12:mi:ss am');
      offer_no = nextval(pg_get_serial_sequence('general_offer', 'custom_id'));
      insert into general_offer(offer_id, price, validity, munite, mb_amount, sms_amount)
      values (offer_no, cost,valid, min, data, sms);
      insert into purchase_offer values(user_no, offer_no, purchased_timestamp);
      insert into notifications values (user_no, 'you have successfully purchased '
      ||min || ' minutes. ' || data || ' mb. ' || sms || ' sms. ' ||cost || ' taka has been deducted from your account balance.'
      ||' the offer will expire on '|| end_date);
      update users set (total_mb, total_talk_time, total_offer_sms, balance) =
      (old_data+data, old_talk_time + min,old_sms+sms,  old_account_balance-cost)
      where mobile_number = user_no;
      messsage := 'Successfully purchased a general offer! :D';
    else
      messsage :=  'Have not sufficient balance :(';
    end if;
    return messsage;

    exception
    when others then
      messsage :=  'Cannot purchase the general offer :(';
      return messsage;
  end;
  $$ language plpgsql;

create or replace function count_general_offer_price( in talk numeric, in data numeric, in sms numeric, in validity numeric)
 returns numeric as $$
declare
  price numeric;
  sms_cost numeric;
  data_cost numeric;
  talk_time_cost numeric;
  pulse_t numeric;
begin
  select call_rate, sms_rate, data_rate, pulse from package into talk_time_cost, sms_cost, data_cost, pulse_t;
  price := sms_cost*3/5 * sms + talk_time_cost/pulse_t*3/5 * talk + data_cost * 1/10 * data + validity * 5;
  return price;
end;

$$ language plpgsql;


create or replace function purchase_internet_offer(in offer_no numeric, in user_no varchar(11)) returns varchar(100) as $$
  declare
    purchased_timestamp timestamptz;
    costt numeric(8,2);
    end_date varchar(100);
    valid numeric;
    reward_point numeric;
    data_total numeric;
    old_reward_point numeric;
    old_account_balance numeric;
    old_data numeric;
    message varchar(100);
  begin
    if not is_valid_number(user_no) then
      return 'Mobile number is not valid';
    end if;
    if not is_valid_data_offer(offer_no) then
      return 'Data offer id is not valid';
    end if;
    purchased_timestamp := now();
    select price, validity, reward_points, data_amount  from internet_offer where  offer_id = offer_no
    into costt, valid, reward_point, data_total;
    select total_reward_point, balance, total_mb from users where mobile_number = user_no
    into  old_reward_point, old_account_balance, old_data;
    raise notice ' %  %', old_account_balance, costt;

    if old_account_balance >= costt then
      end_date := to_char(purchased_timestamp + interval '1 day' * valid, 'yyyy-mm-dd hh12:mi:ss am');
      insert into purchase_offer values (user_no, offer_no,purchased_timestamp);
      insert into notifications values (user_no, 'you have successfully purchased '
      ||data_total || ' mb. '||costt || ' taka has been deducted from your account balance.'
      ||' the data amount will expire on '|| end_date);
      update users set (total_reward_point, total_mb, balance) =
      (old_reward_point+reward_point, old_data + data_total, old_account_balance-costt)
      where mobile_number = user_no;
      message := 'Successfully purchased the data offer! :D';
    else
      message := 'Have not sufficient balance :(';
    end if;
    return message;
   exception
    when others then
    message :=  'Cannot purchase the data offer :(';
    return message;
  end;
  $$ language plpgsql;

create or replace function purchase_reward_offer(in offer_no numeric, in user_no varchar(11)) returns varchar(100) as $$
declare
    purchased_timestamp timestamptz;
    end_date varchar(100);
    valid numeric;
    reward_point numeric;
    data_total numeric;
    old_reward_point numeric;
    old_data numeric;
    message varchar(100);
 begin
  if not is_valid_number(user_no) then
    return 'Mobile number is not valid';
  end if;
  if not is_valid_reward_offer(offer_no) then
    return 'Reward offer id is not valid';
  end if;
    purchased_timestamp := now();
    select  validity, points_need, mb_amount  from reward_offer where  offer_id = offer_no
    into valid, reward_point, data_total;
    select total_reward_point, total_mb from users where mobile_number = user_no
    into old_reward_point, old_data;

    if old_reward_point >= reward_point then
      end_date := to_char(purchased_timestamp + interval '1 day' * valid, 'yyyy-mm-dd hh12:mi:ss am');
      if ((select count(*) from offers where offer_id = offer_no) = 1) then
        raise notice 'is present in the table';
      end if;
      insert into purchase_offer values (user_no, offer_no,purchased_timestamp);
      insert into notifications values (user_no, 'you have successfully purchased '
      ||data_total || ' mb. '|| reward_point || ' reward points have been deducted from your total reward points.'
      ||' the data amount will expire on '|| end_date);
      update users set (total_reward_point, total_mb) =
      (old_reward_point-reward_point, old_data + data_total)
      where mobile_number = user_no;
      message := 'Successfully purchased a data offer using reward points! :D';
    else
      message :=  'Have not sufficient reward points :(';
    end if;
    return message;

  exception
   when others then
    message :=  'Cannot purchase the data offer using the reward points :(';
    return message;
  end;

$$ language plpgsql;

create or replace function make_fnf(in number_by varchar(11), in number_to varchar(11)) returns varchar(100) as $$
declare
  message varchar(100);
  max_fnf_limit numeric;
  current_fnf numeric;
begin
  select count(*) from fnf where fnf_by = number_by into current_fnf;
  select fnf_limit from package where package_id = (select package_id from users
    where mobile_number = number_by) into max_fnf_limit;
  if (current_fnf = max_fnf_limit) then
    return 'You cannot further make fnf as maximum limit has been reached';
  end if;
  if not is_valid_number(number_by) then
    return 'Mobile number is not valid';
  elseif not is_valid_number(number_to) then
    return 'FNF number is not valid';
  end if;
    insert into fnf values(number_by, number_to);
    message := 'Successfully made the fnf';
    return message;
    /*exception when others then
    message := 'Cannot make the fnf';
    return message;*/
end;
$$ language plpgsql;

create or replace function make_link(in number_by varchar(11), in number_to varchar(11)) returns varchar(100) as $$
declare
  message varchar(100);
  current_link numeric;

begin
  select count(*) from link where linked_by = number_by into current_link;
  if current_link = 3 then
    return 'You cannot make further links as maximum limit has been reached';
  end if;
  if not is_valid_number(number_by) then
    return 'Mobile number is not valid';
  elseif not is_valid_number(number_to) then
    return 'Link number is not valid';
  end if;
  insert into link values (number_by, number_to);
  message := 'Successfully made the link! :D';
  return message;
/*  exception when others then
  return 'Cannot make the link :(';*/

end;
$$ language plpgsql;

create or replace function migrate_package(in mob_number varchar(11), in p_name varchar(40)) returns varchar(100) as $$
declare
  p_id numeric;
  message varchar(100);
begin
  if not is_valid_number(mob_number) then
    return 'Mobile number is not valid';
  elsif ((select count(*) from package where package_name = p_name) = 0) then
    return 'Invalid package name';
  end if;
  select package_id from package where package_name = p_name into p_id;
  update users set package_id = p_id where mobile_number = mob_number;
  message := 'Successfully migrated into the package! :D';
  return message;
  exception
  when others then
  return 'Cannot migrate into the package :(';
end;

$$ language plpgsql;


create or replace function take_emergency_balance(in mob_number varchar(11), in amount numeric) returns varchar(100) as $$
declare
  prev_bal numeric;
  prev_due numeric;
  message varchar(100);
begin
  if not is_valid_number(mob_number) then
    return 'Mobile number is not valid';
  end if;
  select balance, emergency_balance_due from users where mobile_number = mob_number
                                                         into prev_bal, prev_due;
  if prev_bal > 0.5 or amount>50 then
    message := 'You are not eligible to take emergency balance :(';
  else
    update users set (balance, emergency_balance_due) = (prev_bal+amount, prev_due+amount) where mobile_number=mob_number;
    insert into emergency_balance values (mob_number, amount, now(), 30);
    message := 'Successfully taken the emergency balance :D';
    insert  into notifications values(mob_number, 'You have successfully taken ' || amount || ' taka emergency balance.');
  end if;
  return message;
  exception
  when others then
  return 'Something error occurred :(';

end;

$$ language plpgsql;

create or replace function transfer_balance( in user_number varchar(11), in user_to_transfer  varchar(11), in amount numeric)
  returns text as $$
declare
  prev_bal_user numeric;
  user_due numeric;
  prev_bal_tt numeric;
begin
  if not is_valid_number(user_number) then
    return 'User number is not valid';
  elseif not is_valid_number(user_to_transfer) then
    return 'Transfer number is not valid';
  end if;
  select balance,emergency_balance_due into prev_bal_user,user_due from users where mobile_number = user_number;
  select balance into prev_bal_tt from users where mobile_number = user_to_transfer;

  if prev_bal_user+2 < amount or user_due>0 then
    return 'Insufficient balance :(';
  else
    update users set balance = (prev_bal_user-amount) where mobile_number = user_number;
    update users set balance = (prev_bal_tt+amount) where mobile_number = user_to_transfer;
    return 'Balance transfer successful! :D';
  end if;
end;

$$ language plpgsql;



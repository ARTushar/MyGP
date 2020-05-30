
drop table purchase_offer;

drop table recharge_history;

drop table internet_history;

drop table sms_history;

drop table call_history;

drop table history;

drop table reward_offer;

drop table sms_offer;

drop table internet_offer;

drop table talk_time_offer;

drop table general_offer;


drop table offers;

drop table stars_offer;

drop table user_voucher;

drop table vouchers;

drop table link;

drop table fnf;


drop table emergency_balance;

drop table notifications;

drop table users;

drop table star;

drop table package;

create table package (
  package_id numeric primary key,
  package_name varchar (40) not null,
  call_rate numeric not null,
  pulse numeric not null,
  sms_rate numeric not null,
  data_rate numeric not null,
  fnf_limit numeric not null
);

create table vouchers(
  voucher_id numeric primary key,
  code numeric not null,
  validity numeric not null,
  description varchar (200) not null
);

create table offers (
  offer_id numeric primary key
);

create table reward_offer (
  offer_id numeric primary key,
  price numeric,
  validity numeric not null,
  reward_points numeric,
  points_need numeric not null,
  mb_amount numeric not null
);

create table sms_offer
(
  offer_id numeric primary key,
  price numeric,
  validity numeric not null,
  reward_points numeric,
	sms_amount numeric not null
);

create table internet_offer(
  offer_id numeric primary key,
  price numeric,
  validity numeric not null,
  reward_points numeric,
  data_amount numeric not null
);

create table talk_time_offer(
  offer_id numeric primary key,
  price numeric,
  validity numeric not null,
  reward_points numeric,
  talk_time numeric not null
);

create table general_offer (
  offer_id numeric primary key,
  price numeric,
  validity numeric not null,
  custom_id serial,
  munite numeric,
  mb_amount numeric,
  sms_amount numeric
);

create table star (
  star_id numeric primary key,
  type varchar (20) not null,
  average_uses numeric not null,
  validity numeric not null
);

create table stars_offer (
  offer_id numeric primary key,
  offer_name varchar(40) not null,
  title varchar (40) not null,
  description varchar (1000),
  star_id numeric not null,
  constraint star_fk foreign key (star_id)
    references star (star_id)
    on delete cascade
);

create table users (
  mobile_number varchar(11) primary key,
  balance numeric(7, 2) not null,
  total_mb numeric(8,3),
  total_reward_point numeric,
  emergency_balance_due numeric,
  user_name varchar(40) not null,
  total_talk_time numeric(8,2),
  total_offer_sms numeric,
  package_id numeric not null,
  star_id numeric,
  star_date timestamptz,
  constraint package_fk foreign key (package_id)
    references package (package_id)
    on delete cascade,
  constraint star_fk foreign key (star_id)
    references star (star_id)
    on delete cascade
);


create table user_voucher (
  user_id varchar(11) not null,
  voucher_id numeric not null,
  constraint user_fk foreign key (user_id)
    references users (mobile_number)
    on delete cascade,
  constraint voucher_fk foreign key (voucher_id)
    references vouchers (voucher_id)
    on delete cascade
);

create table link (
  linked_by varchar(11) not null,
  linked_to varchar(11) not null,
  primary key(linked_by, linked_to),
  constraint linked_by_fk foreign key (linked_by)
    references users (mobile_number) on delete cascade,
  constraint linked_to_fk foreign key (linked_to)
    references users(mobile_number) on delete cascade
);


create table fnf (
  fnf_by varchar(11) not null,
  fnf_to varchar(11) not null,
  primary key(fnf_by, fnf_to),
  constraint fnf_by_fk foreign key (fnf_by)
    references users (mobile_number) on delete cascade,
  constraint fnf_to_fk foreign key (fnf_to)
    references users(mobile_number) on delete cascade
);

create table purchase_offer(
  user_id varchar(11) not null,
  offer_id numeric not null,
  purchase_date timestamptz not null,
  constraint user_id_fk foreign key (user_id)
    references users (mobile_number) on delete cascade,
  constraint offer_id_fk foreign key (offer_id)
    references offers(offer_id) on delete cascade
);


create table history(
  h_date timestamptz not null,
  user_id varchar(11) not null,
  constraint user_fk foreign key (user_id)
    references users (mobile_number) on delete cascade
);

create table recharge_history(
  amount numeric(7, 2) not null,
  validity numeric not null
) inherits (history);

create table internet_history(
  mb_used numeric(8,3) not null
) inherits (history);

create table sms_history(
  sms_number varchar(11) not null,
  cost numeric not null,
  type varchar (40) not null
) inherits (history);

create table call_history(
  call_number varchar(11) not null,
  cost numeric(8,2) not null,
  type varchar (40) not null
) inherits (history);

create table emergency_balance(
  user_id varchar(11) primary key,
  amount numeric not null,
  taken_date timestamptz not null,
  validity numeric not null,
  constraint user_fk foreign key (user_id)
    references users (mobile_number) on delete cascade
);

create table notifications(
  user_id varchar(11) not null,
  message varchar (200) not null,
  constraint user_fk foreign key (user_id)
    references users (mobile_number) on delete cascade
);


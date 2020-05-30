INSERT INTO STAR VALUES (1, 'PLATINUM_PLUS', 4000, 180);
INSERT INTO STAR VALUES (2, 'PLATINUM', 3000, 180);
INSERT INTO STAR VALUES (3, 'GOLD', 2500, 180);
INSERT INTO STAR VALUES (4, 'SILVER', 2000, 180);
INSERT INTO STAR VALUES (0, 'NOT_STAR', 0, 0);



delete from package;
copy package from 'E:\Dopbox\Dropbox\Project MyGP\Tushar\MYGP\MyGP-Database\Data\package.csv'
with (null  'minus',
delimiter ',');


delete from reward_offer;
copy reward_offer from 'E:\Dopbox\Dropbox\Project MyGP\Tushar\MYGP\MyGP-Database\Data\reward_offer.csv'
with (null  'minus',
delimiter ',');

delete from internet_offer;
copy internet_offer
from 'E:\Dopbox\Dropbox\Project MyGP\Tushar\MYGP\MyGP-Database\Data\data_offer.csv'
with (null  'minus',
delimiter ',');


delete from sms_offer;
copy sms_offer
from 'E:\Dopbox\Dropbox\Project MyGP\Tushar\MYGP\MyGP-Database\Data\sms_offer.csv'
with (null  'minus',
delimiter ',');

delete from talk_time_offer;
copy talk_time_offer
from 'E:\Dopbox\Dropbox\Project MyGP\Tushar\MYGP\MyGP-Database\Data\talk_time_offer.csv'
with (null  'minus',
delimiter ',');

delete from users;
copy users
from 'E:\Dopbox\Dropbox\Project MyGP\Tushar\MYGP\MyGP-Database\Data\user.csv'
with (null  'minus',
delimiter ',');

delete from fnf;
copy fnf
from 'E:\Dopbox\Dropbox\Project MyGP\Tushar\MYGP\MyGP-Database\Data\fnf.csv'
with (null  'minus',
delimiter ',');

delete from link;
copy link
from 'E:\Dopbox\Dropbox\Project MyGP\Tushar\MYGP\MyGP-Database\Data\link.csv'
with (null  'minus',
delimiter ',');


delete from purchase_offer;
copy purchase_offer
from 'E:\Dopbox\Dropbox\Project MyGP\Tushar\MYGP\MyGP-Database\Data\purchase_offer.csv'
with (null  'minus',
delimiter ',');

delete from recharge_history;
copy recharge_history
from 'E:\Dopbox\Dropbox\Project MyGP\Tushar\MYGP\MyGP-Database\Data\recharge_history.csv'
with (null  'minus',
delimiter ',');

delete from sms_history;
copy sms_history
from 'E:\Dopbox\Dropbox\Project MyGP\Tushar\MYGP\MyGP-Database\Data\sms_history.csv'
with (null  'minus',
delimiter ',');

delete from internet_history;
copy internet_history
from 'E:\Dopbox\Dropbox\Project MyGP\Tushar\MYGP\MyGP-Database\Data\data_history.csv'
with (null  'minus',
delimiter ',');

delete from call_history;
copy call_history
from 'E:\Dopbox\Dropbox\Project MyGP\Tushar\MYGP\MyGP-Database\Data\call_history.csv'
with (null  'minus',
delimiter ',');


-- copy stars_offer
--   from 'E:\Dropbox\Project MyGP\Tushar\MYGP\MyGP-Database\Data\stars_offer.csv'
--   with (null  'minus',
--   delimiter ',');

insert into stars_offer values (16011,'Panache Hub','12% discount','GP STAR will enjoy 12% discount on all Clothing/ Lifestyle products of PANACHE HUB from its outlet located in Banani/,/ Dhaka (House 48E. Road 13C. Block E. Banani. 1st Dhaka, Bangladesh).To avail the campaign: Write: CODE (HUB) <space> Retail Price (Tk) > & send to 29000
Address & Contact no. of Outlets:
House#48E. Road 13C. Block E. Banani. 1stFloor. Dhaka, Bangladesh
Hot line: 01735237312 / 01822221844
Offer Valid Till:  30 September 2019',1);

insert into stars_offer values (16012,'KZ INTERNATIONAL','10% discount','Offer: GP STAR will enjoy 10% discount on all Clothing, Fashion Jewelry & Lifestyle products of KZ INTERNATIONAL from its all outlets (Except Dhaka Chawkbazar outlet).

 To avail the campaign: Write: CODE (KZ)<space> Retail Price (Tk) & send to 29000',1);

insert into stars_offer values (16013,'REGENT AIRWAYS','12% discount','GP STAR customers will enjoy  upto 12% discount on the base fair of international air ticket at Regent Airways.

10% OFF on International Travel (Economy & Premium Class)
12% OFF on International Travel (Business Class)
BDT 500 OFF on Holiday Packages.
International Routes: Bangkok, Doha, Kolkata, Kuala Lumpur, Muscat & Singapore

Offer Valid Till: 30 January to 31st July 2019',1);

insert into stars_offer values (16014,'THE LAUNDRY BOY','12% discount','Offer:  GP STAR customers can enjoy the below mentioned discount at The Laundry boy:

12% discount on all services.
Not applicable on Shirt, Pant, T.shirt (Automatic wash, Steam press with fold) items
VAT, AIT or other applicable charges will be added
Discount can be availed as many times as a GP STAR can
To avail the campaign: Write LBOY<space> Total Price (Tk.) & send to 29000',1);

insert into stars_offer values (16015,'CAPSIKUM RESTAURANT & PARTY CENTER','10% discount on all items','Offer:  GP STAR customers can enjoy the below mentioned discount at The Laundry boy:

12% discount on all services.
Not applicable on Shirt, Pant, T.shirt (Automatic wash, Steam press with fold) items
VAT, AIT or other applicable charges will be added
Discount can be availed as many times as a GP STAR can
To avail the campaign: Write: CAPSIKUM <space> Total Price (Tk) > & send to 29000',1);


insert into stars_offer values (16016,'REGAL FURNITURE','discount at regal','Offer at Regal Furniture :

OFFER: Regal Furniture will provide mentioned below offers to GP STAR Customers. This are–

When a product category does not have any discount:

10% discount on all Furniture of REGAL Brand:
When a product category already has a discount:

Extra 5% discount on all products of REGAL Brand:
** This offer is applicable for Cash & Credit card purchase only, NO EMI.

Codes :

REGAL10 : 10% discount on all Furniture of REGAL Brand.

REGAL5 : EXTRA 5% discount on all Furniture of REGAL Brand.

How to avail the Offer :  Type Code <space> MRP & send to 29000',1);


insert into stars_offer values (16021,'Panache Hub','10% discount','GP STAR will enjoy 10% discount on all Clothing/ Lifestyle products of PANACHE HUB from its outlet located in Banani/,/ Dhaka (House 48E. Road 13C. Block E. Banani. 1st Dhaka, Bangladesh).To avail the campaign: Write: CODE (HUB) <space> Retail Price (Tk) > & send to 29000
Address & Contact no. of Outlets:
House#48E. Road 13C. Block E. Banani. 1stFloor. Dhaka, Bangladesh
Hot line: 01735237312 / 01822221844
Offer Valid Till:  30 September 2019',2);

insert into stars_offer values (16022,'KZ INTERNATIONAL','8% discount','Offer: GP STAR will enjoy 8% discount on all Clothing, Fashion Jewelry & Lifestyle products of KZ INTERNATIONAL from its all outlets (Except Dhaka Chawkbazar outlet).

 To avail the campaign: Write: CODE (KZ)<space> Retail Price (Tk) & send to 29000',2);

insert into stars_offer values (16023,'REGENT AIRWAYS','10% discount','GP STAR customers will enjoy  upto 10% discount on the base fair of international air ticket at Regent Airways.

8% OFF on International Travel (Economy & Premium Class)
10% OFF on International Travel (Business Class)
BDT 500 OFF on Holiday Packages.
International Routes: Bangkok, Doha, Kolkata, Kuala Lumpur, Muscat & Singapore

Offer Valid Till: 30 January to 31st July 2019',2);

insert into stars_offer values (16024,'THE LAUNDRY BOY','10% discount','Offer:  GP STAR customers can enjoy the below mentioned discount at The Laundry boy:

10% discount on all services.
Not applicable on Shirt, Pant, T.shirt (Automatic wash, Steam press with fold) items
VAT, AIT or other applicable charges will be added
Discount can be availed as many times as a GP STAR can
To avail the campaign: Write LBOY<space> Total Price (Tk.) & send to 29000',2);

insert into stars_offer values (16025,'CAPSIKUM RESTAURANT & PARTY CENTER','10% discount on all items','Offer:  GP STAR customers can enjoy the below mentioned discount at The Laundry boy:

10% discount on all services.
Not applicable on Shirt, Pant, T.shirt (Automatic wash, Steam press with fold) items
VAT, AIT or other applicable charges will be added
Discount can be availed as many times as a GP STAR can
To avail the campaign: Write: CAPSIKUM <space> Total Price (Tk) > & send to 29000',2);


insert into stars_offer values (16026,'REGAL FURNITURE','discount at regal','Offer at Regal Furniture :

OFFER: Regal Furniture will provide mentioned below offers to GP STAR Customers. This are–

When a product category does not have any discount:

8% discount on all Furniture of REGAL Brand:
When a product category already has a discount:

Extra 4% discount on all products of REGAL Brand:
** This offer is applicable for Cash & Credit card purchase only, NO EMI.

Codes :

REGAL10 : 8% discount on all Furniture of REGAL Brand.

REGAL5 : EXTRA 4% discount on all Furniture of REGAL Brand.

How to avail the Offer :  Type Code <space> MRP & send to 29000',2);

insert into stars_offer values (16031,'Panache Hub','8% discount','GP STAR will enjoy 8% discount on all Clothing/ Lifestyle products of PANACHE HUB from its outlet located in Banani/,/ Dhaka (House 48E. Road 13C. Block E. Banani. 1st Dhaka, Bangladesh).To avail the campaign: Write: CODE (HUB) <space> Retail Price (Tk) > & send to 29000
Address & Contact no. of Outlets:
House#48E. Road 13C. Block E. Banani. 1stFloor. Dhaka, Bangladesh
Hot line: 01735237312 / 01822221844
Offer Valid Till:  30 September 2019',3);

insert into stars_offer values (16032,'KZ INTERNATIONAL','8% discount','Offer: GP STAR will enjoy 8% discount on all Clothing, Fashion Jewelry & Lifestyle products of KZ INTERNATIONAL from its all outlets (Except Dhaka Chawkbazar outlet).

 To avail the campaign: Write: CODE (KZ)<space> Retail Price (Tk) & send to 29000',3);

insert into stars_offer values (16033,'REGENT AIRWAYS','8% discount','GP STAR customers will enjoy  upto 8% discount on the base fair of international air ticket at Regent Airways.

8% OFF on International Travel (Economy & Premium Class)
8% OFF on International Travel (Business Class)
BDT 500 OFF on Holiday Packages.
International Routes: Bangkok, Doha, Kolkata, Kuala Lumpur, Muscat & Singapore

Offer Valid Till: 30 January to 31st July 2019',3);

insert into stars_offer values (16034,'THE LAUNDRY BOY','8% discount','Offer:  GP STAR customers can enjoy the below mentioned discount at The Laundry boy:

8% discount on all services.
Not applicable on Shirt, Pant, T.shirt (Automatic wash, Steam press with fold) items
VAT, AIT or other applicable charges will be added
Discount can be availed as many times as a GP STAR can
To avail the campaign: Write LBOY<space> Total Price (Tk.) & send to 29000',3);

insert into stars_offer values (16035,'CAPSIKUM RESTAURANT & PARTY CENTER','8% discount on all items','Offer:  GP STAR customers can enjoy the below mentioned discount at The Laundry boy:

8% discount on all services.
Not applicable on Shirt, Pant, T.shirt (Automatic wash, Steam press with fold) items
VAT, AIT or other applicable charges will be added
Discount can be availed as many times as a GP STAR can
To avail the campaign: Write: CAPSIKUM <space> Total Price (Tk) > & send to 29000',3);


insert into stars_offer values (16036,'REGAL FURNITURE','discount at regal','Offer at Regal Furniture :

OFFER: Regal Furniture will provide mentioned below offers to GP STAR Customers. This are–

When a product category does not have any discount:

8% discount on all Furniture of REGAL Brand:
When a product category already has a discount:

Extra 3% discount on all products of REGAL Brand:
** This offer is applicable for Cash & Credit card purchase only, NO EMI.

Codes :

REGAL10 : 8% discount on all Furniture of REGAL Brand.

REGAL5 : EXTRA 3% discount on all Furniture of REGAL Brand.

How to avail the Offer :  Type Code <space> MRP & send to 29000',3);


insert into stars_offer values (16041,'Panache Hub','6% discount','GP STAR will enjoy 6% discount on all Clothing/ Lifestyle products of PANACHE HUB from its outlet located in Banani/,/ Dhaka (House 48E. Road 13C. Block E. Banani. 1st Dhaka, Bangladesh).To avail the campaign: Write: CODE (HUB) <space> Retail Price (Tk) > & send to 29000
Address & Contact no. of Outlets:
House#48E. Road 13C. Block E. Banani. 1stFloor. Dhaka, Bangladesh
Hot line: 01735237312 / 01822221844
Offer Valid Till:  30 September 2019',4);

insert into stars_offer values (16042,'KZ INTERNATIONAL','6% discount','Offer: GP STAR will enjoy 6% discount on all Clothing, Fashion Jewelry & Lifestyle products of KZ INTERNATIONAL from its all outlets (Except Dhaka Chawkbazar outlet).

 To avail the campaign: Write: CODE (KZ)<space> Retail Price (Tk) & send to 29000',4);

insert into stars_offer values (16043,'REGENT AIRWAYS','6% discount','GP STAR customers will enjoy  upto 6% discount on the base fair of international air ticket at Regent Airways.

6% OFF on International Travel (Economy & Premium Class)
6% OFF on International Travel (Business Class)
BDT 500 OFF on Holiday Packages.
International Routes: Bangkok, Doha, Kolkata, Kuala Lumpur, Muscat & Singapore

Offer Valid Till: 30 January to 31st July 2019',4);

insert into stars_offer values (16044,'THE LAUNDRY BOY','6% discount','Offer:  GP STAR customers can enjoy the below mentioned discount at The Laundry boy:

6% discount on all services.
Not applicable on Shirt, Pant, T.shirt (Automatic wash, Steam press with fold) items
VAT, AIT or other applicable charges will be added
Discount can be availed as many times as a GP STAR can
To avail the campaign: Write LBOY<space> Total Price (Tk.) & send to 29000',4);

insert into stars_offer values (16045,'CAPSIKUM RESTAURANT & PARTY CENTER','6% discount on all items','Offer:  GP STAR customers can enjoy the below mentioned discount at The Laundry boy:

6% discount on all services.
Not applicable on Shirt, Pant, T.shirt (Automatic wash, Steam press with fold) items
VAT, AIT or other applicable charges will be added
Discount can be availed as many times as a GP STAR can
To avail the campaign: Write: CAPSIKUM <space> Total Price (Tk) > & send to 29000',4);


insert into stars_offer values (16046,'REGAL FURNITURE','discount at regal','Offer at Regal Furniture :

OFFER: Regal Furniture will provide mentioned below offers to GP STAR Customers. This are–

When a product category does not have any discount:

6% discount on all Furniture of REGAL Brand:
When a product category already has a discount:

Extra 2% discount on all products of REGAL Brand:
** This offer is applicable for Cash & Credit card purchase only, NO EMI.

Codes :

REGAL10 : 6% discount on all Furniture of REGAL Brand.

REGAL5 : EXTRA 2% discount on all Furniture of REGAL Brand.

How to avail the Offer :  Type Code <space> MRP & send to 29000',4);

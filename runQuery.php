<?php

// -------- Connection Establishment --------

try {
    $dbuser = 'postgres';
    $dbpass = 'tushar1997.';
    $host = 'localhost';
    $dbname='mygp';

    $db = pg_connect("host=$host port=5432 dbname=$dbname user=$dbuser password=$dbpass");
}catch (PDOException $e) {
    echo "Error : " . $e->getMessage() . "<br/>";
    die();
}

// -------- Other Variables -------

$q = $_REQUEST['q'];


// -------- Simple -------
$mobile_number = "";
if(isset($_POST['num']) and $_POST['num'] != null) {
    $mobile_number = $_POST['num'];
}

$simple_query1 = "select user_name, balance, total_mb, total_talk_time, total_offer_sms, total_reward_point,
       (select package_name from package where package_id = us.package_id) package_name,
       (select type from star where star_id = us.star_id) star_status
	from users us
	where mobile_number = '".$mobile_number."'";

$simple_query2 = "select call_number, to_char(h_date, 'YYYY-MM-DD HH12:MI:SS PM') as date, cost, type
from call_history where user_id = '".$mobile_number."'";

$simple_query3 = "select mb_used, to_char(h_date, 'YYYY-MM-DD HH12:MI:SS PM') as date
from internet_history where user_id = '".$mobile_number."'";

$simple_query4 = "select sms_number, to_char(h_date, 'YYYY-MM-DD HH12:MI:SS PM') as date, cost, type
from sms_history where user_id = '".$mobile_number."'";

$simple_query5 = "select amount, validity, to_char(h_date, 'YYYY-MM HH12:MI:SS PM') as recharged_time
from recharge_history where  user_id = '".$mobile_number."'";

$simple_query6 = "select offer_id, mb_amount, points_need, validity
from reward_offer";

$simple_query7 = "select offer_id, talk_time, validity, price, reward_points
from talk_time_offer";

$simple_query8 = "select offer_id, sms_amount, validity, price, reward_points
from sms_offer";

$simple_query9 = "select offer_id, data_amount, validity, price, reward_points
from internet_offer";

$simple_query10 = "select package_name, call_rate, data_rate, fnf_limit, pulse
from package";

$simple_query11 = "select offer_name, title, description, (select type from star where star_id = so.star_id) star_status
from stars_offer so
where star_id = (
  select star_id from users
  where mobile_number = "."'$mobile_number')";

$simple_query12 = "select message from notifications
where user_id = '$mobile_number'";

$simple_query13 = "select fnf_to from fnf where fnf_by = '$mobile_number'";

$simple_query14 = "select linked_to from link where linked_by = '$mobile_number'";

$simple_query15 = "select offer_id from offers order by offer_id;";




// ------- Complex ---------
$complex_query1 = "select offer_id , price, (select count(*) from purchase_offer where offer_id = io.offer_id) purchase_count from internet_offer io
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
order by purchase_count desc ;";


$complex_query2 = "select fn.fnf_by,  fn.fnf_to,
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
     ) as cnt
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
     )";

$complex_query3 = "select user_name, (
  coalesce((select count(*)
  from sms_history where
      user_id = u.mobile_number and now() - h_date <= interval  '1 day' * 90
                     and type = 'outgoing'), 0)) sms_sent
from users u
where 3 <= (coalesce((select max(tab.max_count) from (select count(*) max_count from purchase_offer where user_id = u.mobile_number
                      and now() - purchase_date <= interval '1 day' * 60
                      group by offer_id) tab),0))";


$complex_query4 = "select user_name, mobile_number  from users u
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
  )";


$complex_query5 = "select user_name, mobile_number, (
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
  ) max_users_table)";


$complex_query6 = "select user_name, (
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
  coalesce((select count(*) from link where linked_to = u.mobile_number),0))";

$complex_query7 = "select str.type ,
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
from star str";

$complex_query8 = "select mobile_number, user_name ,
       (select type from star where star_id = us.star_id) star_status,
       (select count(*) from call_history ch
       where ch.user_id = us.mobile_number and (now() - h_date) < interval '1 day'*90) total_call_made,
       (select count(*) from sms_history sh
       where sh.user_id = us.mobile_number and (now() - h_date) < interval '1 day'*90) total_sms_made
from users us
where package_id = (
  select package_id from package
  where package_name = 'BONDHU'
  ) and star_id > 0";



// ------ table created ------

echo "<table class=\"w3-table-all w3-hoverable w3-padding\">";
if ($q == '11') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "Name" . '</th>';
    echo '<th width="150" align=center>' . "Balance" . '</th>';
    echo '<th width="150" align=center>' . "Total Data" . '</th>';
    echo '<th width="150" align=center>' . "Total Talk Time" . '</th>';
    echo '<th width="150" align=center>' . "Total SMS" . '</th>';
    echo '<th width="150" align=center>' . "Reward Points" . '</th>';
    echo '<th width="150" align=center>' . "Package" . '</th>';
    echo '<th width="150" align=center>' . "Star Status" . '</th>';
    echo "</tr>";

    $result = pg_query($db, $simple_query1);
} else if ($q == '12') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "Call Number" . '</th>';
    echo '<th width="150" align=center>' . "Date" . '</th>';
    echo '<th width="150" align=center>' . "Cost" . '</th>';
    echo '<th width="150" align=center>' . "Type" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $simple_query2);
} else if ($q == '13') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "Data used" . '</th>';
    echo '<th width="150" align=center>' . "Date" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $simple_query3);
} else if ($q == '14') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "SMS Number" . '</th>';
    echo '<th width="150" align=center>' . "Date" . '</th>';
    echo '<th width="150" align=center>' . "Cost" . '</th>';
    echo '<th width="150" align=center>' . "Type" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $simple_query4);
} else if ($q == '15') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "Amount" . '</th>';
    echo '<th width="150" align=center>' . "Validity" . '</th>';
    echo '<th width="150" align=center>' . "Rechage Time" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $simple_query5);
} else if ($q == '16') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "Offer ID" . '</th>';
    echo '<th width="150" align=center>' . "MB Amount" . '</th>';
    echo '<th width="150" align=center>' . "Points Need" . '</th>';
    echo '<th width="150" align=center>' . "Validity" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $simple_query6);
} else if ($q == '17') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "Offer ID" . '</th>';
    echo '<th width="150" align=center>' . "Talk Time" . '</th>';
    echo '<th width="150" align=center>' . "Validity" . '</th>';
    echo '<th width="150" align=center>' . "Price" . '</th>';
    echo '<th width="150" align=center>' . "Reward Points" . '</th>';
    $result = pg_query($db, $simple_query7);
} else if ($q == '18') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "Offer ID" . '</th>';
    echo '<th width="150" align=center>' . "SMS Amount" . '</th>';
    echo '<th width="150" align=center>' . "Validity" . '</th>';
    echo '<th width="150" align=center>' . "Price" . '</th>';
    echo '<th width="150" align=center>' . "Reward Points" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $simple_query8);
} else if ($q == '19') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "Offer ID" . '</th>';
    echo '<th width="150" align=center>' . "Data Amount" . '</th>';
    echo '<th width="150" align=center>' . "Validity" . '</th>';
    echo '<th width="150" align=center>' . "Price" . '</th>';
    echo '<th width="150" align=center>' . "Reward Points" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $simple_query9);
} else if ($q == '20') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "Package Name" . '</th>';
    echo '<th width="150" align=center>' . "Call Rate" . '</th>';
    echo '<th width="150" align=center>' . "Data Rate" . '</th>';
    echo '<th width="150" align=center>' . "FNF Limit" . '</th>';
    echo '<th width="150" align=center>' . "Pulse" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $simple_query10);
} else if ($q == '21') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "Offer Name" . '</th>';
    echo '<th width="150" align=center>' . "Title" . '</th>';
    echo '<th width="150" align=center>' . "Description" . '</th>';
    echo '<th width="150" align=center>' . "Eligible Star" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $simple_query11);
}
else if($q == '22') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "Notifications Message" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $simple_query12);
}
else if($q == '23') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "FNF Number" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $simple_query13);
}
else if($q == '24') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "Linked Number" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $simple_query14);
}
else if($q == '25') {
    echo "<tr>";
    echo '<th width="150" align=center>' . "Offer ID" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $simple_query15);
}

else if($q == '31'){
    echo "<tr>";
    echo '<th width="150" align=center>' . "Offer ID" . '</th>';
    echo '<th width="150" align=center>' . "Price" . '</th>';
    echo '<th width="150" align=center>' . "Number of Times Purchased" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $complex_query1);
}
else if($q == '32'){
    echo "<tr>";
    echo '<th width="150" align=center>' . "User ID" . '</th>';
    echo '<th width="150" align=center>' . "FNF Number" . '</th>';
    echo '<th width="150" align=center>' . "Total Called" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $complex_query2);
}
else if($q == '33'){
    echo "<tr>";
    echo '<th width="150" align=center>' . "User Name" . '</th>';
    echo '<th width="150" align=center>' . "SMS Sent" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $complex_query3);
}
else if($q == '34'){
    echo "<tr>";
    echo '<th width="150" align=center>' . "User Name" . '</th>';
    echo '<th width="150" align=center>' . "Mobile Number" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $complex_query4);
}
else if($q == '35'){
    echo "<tr>";
    echo '<th width="150" align=center>' . "User Name" . '</th>';
    echo '<th width="150" align=center>' . "Mobile Number" . '</th>';
    echo '<th width="150" align=center>' . "Star Status" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $complex_query5);
}
else if($q == '36'){
    echo "<tr>";
    echo '<th width="150" align=center>' . "User Name" . '</th>';
    echo '<th width="150" align=center>' . "Total Used Amount" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $complex_query6);
}
else if($q == '37'){
    echo "<tr>";
    echo '<th width="150" align=center>' . "Star Type" . '</th>';
    echo '<th width="150" align=center>' . "Internet Offer Count" . '</th>';
    echo '<th width="150" align=center>' . "Talk TIme Offer Count" . '</th>';
    echo '<th width="150" align=center>' . "SMS Offer Count" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $complex_query7);
}
else if($q == '38'){
    echo "<tr>";
    echo '<th width="150" align=center>' . "Mobile Number" . '</th>';
    echo '<th width="150" align=center>' . "User Name" . '</th>';
    echo '<th width="150" align=center>' . "Star Type" . '</th>';
    echo '<th width="150" align=center>' . "Total Calls Made" . '</th>';
    echo '<th width="150" align=center>' . "Total SMS Made" . '</th>';
    echo "</tr>";
    $result = pg_query($db, $complex_query8);
}

else if($q == '62') {
	$result = pg_query($db, "insert into internet_offer values (12000, 50, 10, 10, 50)");
}
else if($q == '63') {
	$result = pg_query($db, "insert into sms_offer values (10000, 20, 2, 2, 50)");
}
else if($q == '64') {
	$result = pg_query($db, "insert into talk_time_offer values (11000, 20, 7, 20, 20)");
}
else if($q == '65') {
	$result = pg_query($db, "insert into reward_offer values (13000, 0, 20, 0, 10, 20)");
}
else if($q == '66') {
	$result = pg_query($db, "insert into general_offer values (14000, 20, 2, 200, 20, 10, 0)");
}

if (!$result) {
    echo "An error occurred in query.\n";
    exit;
}


while ($row = pg_fetch_row($result)) {
    echo "<tr>";
    foreach ($row as $item) {
        echo "<td width='150' align=center>" . $item . '</td>';
    }
    echo "</tr>";
}
echo "</table>";
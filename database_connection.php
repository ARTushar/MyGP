<?php
/**
 * Created by PhpStorm.
 * User: tusha
 * Date: 2/7/2019
 * Time: 11:28 PM
 */

 $host = "host = localhost";
 $port = "port = 5432";
 $dbname = "dbname = mygp";
 $user = "user = postgres";
 $password = "password = tushar1997.";

/* $db = pg_connect("$host $port $dbname $user $password");
 if(!$db){
     echo "Error : unable to open database";

 }
 else {
     echo "Opened database successfully\n";
 }*/

 $myPDO = new PDO('pgsql:host = localhost; port = 5432; dbname = mygp', 'postgres', 'tushar1997.');
$result = $myPDO->query("select user_name from users u
where package_id  = (select package_id
  from package where package_name = 'DJUICE'
  ) and (
    count_used_amount(u.mobile_number, 60) >= 1000
  )
");

foreach ($result->fetchAll() as $item) {
    echo "$item[user_name] \n";
}
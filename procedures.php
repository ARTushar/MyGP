<?php

// -------- connection establishment --------

try {
    $dbuser = 'postgres';
    $dbpass = 'tushar1997.';
    $host = 'localhost';
    $dbname='mygp';

    $db = pg_connect("host=$host port=5432 dbname=$dbname user=$dbuser password=$dbpass");
}catch (pdoexception $e) {
    echo "error : " . $e->getmessage() . "<br/>";
    die();
}

// -------- other variables -------

$q = "";
$mobile_number = "";
$mobile_number2 = "";
$amount = "";
$offer_id = "";
$min = "";
$data = "";
$sms = "";
$valid = "";
$linkOrFnfNum = "";
$pack_name = "";

$q = $_REQUEST['q'];
echo $q;
$mobile_number = $_POST['num'];

if ($q == '1' or $q == '10' or $q == '11') $amount = $_POST['amount'];
else if ($q == '2' or $q == '3' or $q == '4' or $q == '5') $offer_id = $_POST['off_id'];
else if ($q == '6') {
    $min = $_POST['min'];
    $data = $_POST['data'];
    $sms = $_POST['sms'];
    $valid = $_POST['valid'];
}
else if ($q == '7') {
    $linkOrFnfNum = $_POST['fnf_num'];
}
else if ($q == '8') {
    $linkOrFnfNum = $_POST['link_num'];
}
else if ($q == '9') {
    $pack_name = $_POST['pack_name'];
}
if ($q == '11') {
    $mobile_number2 = $_POST['num2'];
}
// ----- Definition of the procedures ------
$recharge_acc = "select RECHARGE_ACCOUNT('".$mobile_number."' ,".$amount.");";
$purchase_internet_offer = "select PURCHASE_INTERNET_OFFER(".$offer_id." ,'".$mobile_number."');";
$purchase_talk_time_offer = "select PURCHASE_TALK_TIME_OFFER(".$offer_id." ,'".$mobile_number."');";
$purchase_sms_offer = "select PURCHASE_SMS_OFFER(".$offer_id." ,'".$mobile_number."');";
$purchase_reward_offer = "select PURCHASE_REWARD_OFFER(".$offer_id." ,'".$mobile_number."');";
$purchase_general_offer = "select PURCHASE_GENERAL_OFFER('".$mobile_number."' ,".$min.",".$data." ,".$sms.",".$valid.");";
$make_fnf = "select make_fnf('".$mobile_number."' ,'".$linkOrFnfNum."');";
$make_link = "select make_link('".$mobile_number."' ,'".$linkOrFnfNum."');";
$migrate_package = "select migrate_package('".$mobile_number."',"."'".$pack_name."'".");";
$take_emergency_balance = "select take_emergency_balance('".$mobile_number."' ,".$amount.");";
$transfer_balance = "select transfer_balance('".$mobile_number."' ,'".$mobile_number2."' ,".$amount.");";

// ----- Calling the procedures ------

if ($q == '1') $result = pg_query($db, $recharge_acc);
else if ($q == '2') $result = pg_query($db, $purchase_internet_offer);
else if ($q == '3') $result = pg_query($db, $purchase_talk_time_offer);
else if ($q == '4') $result = pg_query($db, $purchase_sms_offer);
else if ($q == '5') $result = pg_query($db, $purchase_reward_offer);
else if ($q == '6') $result = pg_query($db, $purchase_general_offer);
else if ($q == '7') $result = pg_query($db, $make_fnf);
else if ($q == '8') $result = pg_query($db, $make_link);
else if ($q == '9') $result = pg_query($db, strtoupper($migrate_package));
else if ($q == '10') $result = pg_query($db, $take_emergency_balance);
else if ($q == '11') $result = pg_query($db, $transfer_balance);

$row = pg_fetch_array($result);
echo "</br>";
echo $row[0];

?>
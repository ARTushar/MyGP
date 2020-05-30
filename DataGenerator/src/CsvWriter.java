import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.*;
@SuppressWarnings("Duplicates")

public class CsvWriter {
    private Random random;
    private Scanner scanner;
    private ArrayList<String> userNameList;
    private HashMap<String, String> packageName;
    private ArrayList<String> timstampList;
    Map<String, String> userNumberMap;
    private ArrayList<String> offerID;
    private String[] type;
    private String[] amount;

    public CsvWriter() {
        random = new Random();
        packageName = new HashMap<>();
        timstampList = new ArrayList<>();
        type = new String[]{"incoming", "outgoing"};
        packageName.put("10", "DJUICE,22,10,0.50,1,10");
        packageName.put("11", "NISCHINTO,22,10,0.50,1,3");
        packageName.put("12", "BONDHU,27.5,10,0.50,1,18");
        packageName.put("13", "SMILE,28,10,0.50,1,3");
        userNameList = new ArrayList<>();
        userNumberMap = new HashMap<>();
        offerID = new ArrayList<>();
        amount = new String[]{"10", "20", "50", "100", "200", "500", "99", "30"};
        setUserNameList();
        setTimestampList();
    }

    private String generateID(String start_code, int length) {
        String toret = start_code;
        int x;
        for (int i = 0; i < length; i++) {
            x = random.nextInt(10);
            toret += x;
        }
        return toret;
    }

    private void setUserNameList() {
        try {
            scanner = new Scanner(new File("nameList.txt"));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        while (scanner.hasNext()) {
            String temp = scanner.nextLine();
            userNameList.add(temp);
        }
    }

    private void setTimestampList() {
        try {
            scanner = new Scanner(new File("timestamp.csv"));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        while (scanner.hasNext()) {
            timstampList.add(scanner.nextLine());
        }
    }

    public void generateUserDataCSV(String fileName, int totalData) {

        try (PrintWriter writer = new PrintWriter(new File(fileName))) {
            StringBuilder str = new StringBuilder();
           /* str.append("mobile_number,balance,total_mb," +
                    "total_reward_point,emergency_balance_due," +
                    "user_name,total_talk_time,total_offer_sms,package_id," +
                    "star_id,star_date\n");*/
            for (int i = 0; i < totalData; i++) {
                String mobNumber;
                String starId;
                do {
                    mobNumber = generateID("017", 8);
                } while (userNumberMap.containsKey(mobNumber));
                userNumberMap.put(mobNumber, userNameList.get(random.nextInt(userNameList.size())));
                //mobile number
                str.append(mobNumber);
                str.append(",");
                //account balance
                str.append(random.nextInt(20000) / 100.0);
                str.append(",");
                //total data
                str.append(random.nextInt(20000 * 1000) / 1000.0);
                str.append(",");
                //total reward points
                str.append(random.nextInt(1000));
                str.append(",");
                str.append(0);
                str.append(",");
                //user name
                str.append(userNumberMap.get(mobNumber));
                str.append(",");
                //total talk time
                str.append(random.nextInt(200 * 100) / 100.0);
                str.append(",");
                // total sms
                str.append(random.nextInt(200));
                str.append(",");
                //package id
                str.append((10 + random.nextInt(4)));
                str.append(",");
                starId = String.valueOf(random.nextInt(5));
                //star id
                str.append(starId);
                str.append(",");
                //star date
                if (starId.equals("0"))
                    str.append("minus");
                else
                    str.append(timstampList.get(random.nextInt(timstampList.size())));
                str.append("\n");

            }
            writer.write(str.toString());
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void generatePackageDataCSV(String fileName) {
        try (PrintWriter writer = new PrintWriter(new File(fileName))) {
            StringBuilder str = new StringBuilder();
            for (String key : packageName.keySet()) {
                //package id
                str.append(key);
                str.append(",");
                //package details serially
                str.append(packageName.get(key));
                str.append("\n");
            }
            writer.write(str.toString());

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void generateSmsOffer(String fileName, int totalData) {
        assert totalData < 9 * 9 * 9 : "Overweight data";
        try (PrintWriter writer = new PrintWriter(new File(fileName))) {
            StringBuilder str = new StringBuilder();
            Map<String, String> mapID = new HashMap<>();
            String id;
            for (int i = 1; i <= totalData; i++) {
                do {
                    id = generateID("10", 3);
                } while (mapID.containsKey(id));
                mapID.put(id, id);
                offerID.add(id);
                //id
                str.append(id);
                str.append(",");
                //price
                str.append(5 * i);
                str.append(",");
                //validity
                str.append(i);
                str.append(",");
                //rewards points
                str.append(2 * i);
                str.append(",");
                //sms_amount
                str.append(50 * i);
                str.append("\n");
            }
            writer.write(str.toString());

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void generateTalkTimeOffer(String fileName, int totalData) {
        assert totalData < 9 * 9 * 9 : "Overweight data";
        try (PrintWriter writer = new PrintWriter(new File(fileName))) {
            StringBuilder str = new StringBuilder();
            Map<String, String> mapID = new HashMap<>();
            String id;
            for (int i = 1; i <= totalData; i++) {
                do {
                    id = generateID("11", 3);
                } while (mapID.containsKey(id));
                mapID.put(id, id);
                offerID.add(id);
                //id
                str.append(id);
                str.append(",");
                //price
                str.append(5 * i);
                str.append(",");
                //validity
                str.append(i);
                str.append(",");
                //rewards points
                str.append(2 * i);
                str.append(",");
                //talk time
                str.append(10 * i);
                str.append("\n");
            }
            writer.write(str.toString());

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void generateDataOffer(String fileName, int totalData) {
        assert totalData < 9 * 9 * 9 : "Overweight data";
        try (PrintWriter writer = new PrintWriter(new File(fileName))) {
            StringBuilder str = new StringBuilder();
            Map<String, String> mapID = new HashMap<>();
            String id;
            for (int i = 1; i <= totalData; i++) {
                do {
                    id = generateID("12", 3);
                } while (mapID.containsKey(id));
                mapID.put(id, id);
                offerID.add(id);
                //id
                str.append(id);
                str.append(",");
                //price
                str.append(20 * i);
                str.append(",");
                //validity
                str.append(i);
                str.append(",");
                //rewards points
                str.append(2 * i);
                str.append(",");
                //data amount
                str.append(100 * i);
                str.append("\n");
            }
            writer.write(str.toString());

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void generateRewardOffer(String fileName, int totalData) {
        assert totalData < 9 * 9 * 9 : "Overweight data";
        try (PrintWriter writer = new PrintWriter(new File(fileName))) {
            StringBuilder str = new StringBuilder();
            Map<String, String> mapID = new HashMap<>();
            String id;
            for (int i = 1; i <= totalData; i++) {
                do {
                    id = generateID("13", 3);
                } while (mapID.containsKey(id));
                mapID.put(id, id);
                offerID.add(id);
                //id
                str.append(id);
                str.append(",");
                //price
                str.append(0);
                str.append(",");
                //validity
                str.append(i);
                str.append(",");
                //rewards points
                str.append(0);
                str.append(",");
                //reward points need
                str.append(5*i);
                str.append(",");
                //data amount
                str.append(10 * i);
                str.append("\n");
            }
            writer.write(str.toString());

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void generateCallHistory(String fileName, int totalData) {
        assert totalData < 9 * 9 * 9 : "Overweight data";
        try (PrintWriter writer = new PrintWriter(new File(fileName))) {
            StringBuilder str = new StringBuilder();
            String[] userNumber = userNumberMap.keySet().toArray(new String[0]);
            for (int i = 1; i <= totalData; i++) {
                String callby, callto, cost, tt;
                do {
                    callby = userNumber[random.nextInt(userNumber.length)];
                    callto = userNumber[random.nextInt(userNumber.length)];
                } while (callby.equals(callto));
                //date and time
                str.append(timstampList.get(random.nextInt(timstampList.size())));
                str.append(",");
                //user id
                str.append(callby);
                str.append(",");
                //called number
                str.append(callto);
                str.append(",");
                tt = type[random.nextInt(2)];
                if (tt.equals("incoming")) cost = "0";
                else cost = String.valueOf((random.nextInt(300) + 100) / 100.0);
                //cost
                str.append(cost);
                str.append(",");
                //type
                str.append(tt);
                str.append("\n");
            }
            writer.write(str.toString());

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void generateSMSHistory(String fileName, int totalData) {
        assert totalData < 9 * 9 * 9 : "Overweight data";
        try (PrintWriter writer = new PrintWriter(new File(fileName))) {
            StringBuilder str = new StringBuilder();
            String[] userNumber = userNumberMap.keySet().toArray(new String[0]);
            for (int i = 1; i <= totalData; i++) {
                String messageBy, MessageTo, cost, tt;
                do {
                    messageBy = userNumber[random.nextInt(userNumber.length)];
                    MessageTo = userNumber[random.nextInt(userNumber.length)];
                } while (messageBy.equals(MessageTo));
                //date and time
                str.append(timstampList.get(random.nextInt(timstampList.size())));
                str.append(",");
                //user id
                str.append(messageBy);
                str.append(",");
                //sms number
                str.append(MessageTo);
                str.append(",");
                tt = type[random.nextInt(2)];
                if (tt.equals("incoming")) cost = "0";
                else cost = String.valueOf(0.50);
                //cost
                str.append(cost);
                str.append(",");
                //type
                str.append(tt);
                str.append("\n");
            }
            writer.write(str.toString());

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }
    public void generateDataHistory(String fileName, int totalData) {
        try (PrintWriter writer = new PrintWriter(new File(fileName))) {
            StringBuilder str = new StringBuilder();
            String[] userNumber = userNumberMap.keySet().toArray(new String[0]);
            for (int i = 1; i <= totalData; i++) {
                String usedBy = userNumber[random.nextInt(userNumber.length)];
                //date and time
                str.append(timstampList.get(random.nextInt(timstampList.size())));
                str.append(",");

                // used by
                str.append(usedBy);
                str.append(",");

                //mb used
                str.append(random.nextInt(100*1000) / 1000.0);
                str.append("\n");
            }
            writer.write(str.toString());

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void generateRechargeHistory(String fileName, int totalData) {
        try (PrintWriter writer = new PrintWriter(new File(fileName))) {
            StringBuilder str = new StringBuilder();
            String[] userNumber = userNumberMap.keySet().toArray(new String[0]);
            for (int i = 0; i < totalData; i++) {
                String userno = userNumber[random.nextInt(userNumber.length)];

                //date and time
                str.append(timstampList.get(random.nextInt(timstampList.size())));
                str.append(",");
                //user id
                str.append(userno);
                str.append(",");
                //amount
                str.append(amount[random.nextInt(amount.length)]);
                str.append(",");
                //type
                str.append("60");
                str.append("\n");
            }
            writer.write(str.toString());

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void generatePurchaseOffer(String fileName, int totalData){
        try (PrintWriter writer = new PrintWriter(new File(fileName))) {
            StringBuilder str = new StringBuilder();
            String[] userNumber = userNumberMap.keySet().toArray(new String[0]);
            for (int i = 0; i < totalData; i++) {
                String userno = userNumber[random.nextInt(userNumber.length)];
                //user id
                str.append(userno);
                str.append(",");
                str.append(offerID.get(random.nextInt(offerID.size())));
                str.append(",");
                //date and time
                str.append(timstampList.get(random.nextInt(timstampList.size())));
                str.append("\n");
            }
            writer.write(str.toString());

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void generateFnf(String fileName) {
        try (PrintWriter writer = new PrintWriter(new File(fileName))) {
            StringBuilder str = new StringBuilder();
            String[] userNumber = userNumberMap.keySet().toArray(new String[0]);
            for (int i = 0; i < userNumber.length; i+=2) {
                String fnf1, fnf2, fnf3;
                fnf1 = userNumber[i];
                do{
                    fnf2 = userNumber[random.nextInt(userNumber.length)];
                    fnf3 = userNumber[random.nextInt(userNumber.length)];
                }while(fnf1.equals(fnf2) || fnf1.equals(fnf3) || fnf2.equals(fnf3));
                str.append(fnf1);
                str.append(",");
                str.append(fnf2);
                str.append("\n");
                str.append(fnf1);
                str.append(",");
                str.append(fnf3);
                str.append("\n");
            }
            writer.write(str.toString());

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

    }

    public void generateLink(String fileName){
        try (PrintWriter writer = new PrintWriter(new File(fileName))) {
            StringBuilder str = new StringBuilder();
            String[] userNumber = userNumberMap.keySet().toArray(new String[0]);
            for (int i = 0; i < userNumber.length; i+=3) {
                String link1, link2, link3;
                link1 = userNumber[i];
                do{
                    link2 = userNumber[random.nextInt(userNumber.length)];
                    link3 = userNumber[random.nextInt(userNumber.length)];
                }while(link1.equals(link2) || link1.equals(link3) || link2.equals(link3));
                str.append(link1);
                str.append(",");
                str.append(link2);
                str.append("\n");
                str.append(link1);
                str.append(",");
                str.append(link3);
                str.append("\n");
            }
            writer.write(str.toString());

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }
}

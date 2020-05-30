public class Main {
    public static void main(String[] args) {
        CsvWriter csvWriter = new CsvWriter();
        csvWriter.generateUserDataCSV("user.csv", 500);
        csvWriter.generatePackageDataCSV("package.csv");
        csvWriter.generateDataOffer("data_offer.csv",20);
        csvWriter.generateSmsOffer("sms_offer.csv",20);
        csvWriter.generateRewardOffer("reward_offer.csv", 20);
        csvWriter.generateTalkTimeOffer("talk_time_offer.csv", 20);
        csvWriter.generateFnf("fnf.csv");
        csvWriter.generateLink("link.csv");
        csvWriter.generateCallHistory("call_history.csv",10000);
        csvWriter.generateDataHistory("data_history.csv", 10000);
        csvWriter.generateSMSHistory("sms_history.csv", 10000);
        csvWriter.generatePurchaseOffer("purchase_offer.csv", 10000);
        csvWriter.generateRechargeHistory("recharge_history.csv", 10000);
    }
}

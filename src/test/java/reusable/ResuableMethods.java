package reusable;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.TimeUnit;
import java.util.regex.Pattern;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.MongoClient;
import com.mongodb.MongoCredential;
import com.mongodb.ServerAddress;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;



public class ResuableMethods {

    public static String glbToken = null;
    public static String glbServiceRequestBaseURL = null;
    
    public static MongoClient mongoClient = null;
    public static MongoCredential mongoCredential = null;
    
    public static String mongoUser = null;
    public static String mongoPassword = null;
    public static String mongoDatasbeName = null;
    public static int mongoLocalHost = 0;
    
    public static String userName = "sql_ic_srsvc";
	public static String password = "tEwRefCA6ybrtAxw7ajm";
	public static Connection con;
	public static Statement stmt;
	public static ResultSet result;
    
    public static String glblEnvironment;
    public static String glblChannel;

    public Map<String, Object> howToCallNonStaticMethodInJavaExample(String fromJs) {
        Map<String, Object> map = new HashMap<>();
        map.put("someKey", "hello " + fromJs);
        return map;
    }

    public static String howToCallStaticMethodInJavaExample(String fromJs) {
        return "hello " + fromJs;
    }

    public static boolean socks5BypassConfig(){

        try{
            System.setProperty("http.proxyHost", "localhost");
            System.setProperty("http.proxyPort", "8080");
            //System.setProperty("http.proxyPort", "1080");

            return true;
        }catch(Exception e){
            System.err.println(e);
            return false;
        }

    }

    public static boolean geProxyConfig() {

        try {
            System.setProperty("https.proxyHost", "pitc-zscaler-americas-cincinnati3pr.proxy.corporate.ge.com");
            System.setProperty("https.proxyPort", "80");
            return true;
        } catch (Exception e) {
            System.err.println(e);
            return false;
        }

    }
    
	//Generate unique nunmeric
    public static int generateRandomNumber(){
    	
		Random rand = new Random();
		int  randomNumber = 100000000 + rand.nextInt(900000000);
		return randomNumber;

    }
    
    public static void connectToMongo(String environment, String channel) {
    	
    	mongoUser = "event_user"; //can add to condition if needed
    	
    	
    	if(environment.equalsIgnoreCase("ver")){
    		
    		mongoPassword = "9ZUyd2ubCeBzwPCJ";
    		
    		if(channel.equals("01")){
    			mongoLocalHost = 27120;
    		}else if(channel.equals("02")){
    			mongoLocalHost = 27119;
    		}else if(channel.equals("03")){
    			mongoLocalHost = 27118;
    		}
    		
    	}else if(environment.equalsIgnoreCase("dev")){
    		mongoPassword = "6aUFGg5yhb7edyBx";
    		mongoLocalHost = 27116;
    		
    	}else if(environment.equalsIgnoreCase("val")){
    			//not setup yet
    		
    	}else{ //default to ver
    		mongoPassword = "9ZUyd2ubCeBzwPCJ";
    		
    		if(channel.equals("01")){
    			mongoLocalHost = 27120;
    		}else if(channel.equals("02")){
    			mongoLocalHost = 27119;
    		}else if(channel.equals("03")){
    			mongoLocalHost = 27118;
    		}
    		
    	}
    	
        mongoCredential = MongoCredential.createScramSha1Credential(mongoUser, "gehc_ic_" + environment +"_us_mgo_event_" + channel +"_01",
        		mongoPassword.toCharArray());

        mongoClient = new MongoClient(new ServerAddress("127.0.0.1", mongoLocalHost), Arrays.asList(mongoCredential));

        
        glblEnvironment = environment;
        glblChannel = channel;
        
        //need to figure out where to insert the below code to avoid resource leak
    	//mongoClient.close();

	}
    
    public static boolean checkMongoCollection(String collection, String dynamicParam, String loadStatus) throws Exception {
    	
    	String dynamicCollection = "";
    	String tmpQuery1 = "";
    	String tmpQuery2 = "";
    	String tmpQuery3 = "category";
    	String tmpQuery4 = "source";
    	
    	boolean ServiceRequestColMatch = Pattern.matches("(?i).*service.*request.*", collection); 
    	boolean ServiceRequestTaskColMatch = Pattern.matches("(?i).*task.*", collection); 
    	boolean ServiceRequestPartsColMatch = Pattern.matches("(?i).*part.*", collection); 
    	boolean ServiceRequestTimesheetColMatch = Pattern.matches("(?i).*timesheet.*", collection); 
    	
    	if(ServiceRequestColMatch == true){
    		dynamicCollection = "ServiceRequest";
    	}else if(ServiceRequestTaskColMatch == true){
    		dynamicCollection = "Task";
    	}else if (ServiceRequestPartsColMatch == true){
    		dynamicCollection = "Part";
    	}else if(ServiceRequestTimesheetColMatch == true){
    		dynamicCollection = "Timesheet";
    	}else{
    		dynamicCollection = "unable to get valid collection";
    	}
    	
    	
    //	if((ServiceRequestColMatch == true) && loadStatus.equalsIgnoreCase("FAILED")){
    		tmpQuery1 = "value.loadUid";
    		tmpQuery2 = "value.loadStatus";
    //	}else if((ServiceRequestColMatch == true) && !loadStatus.equalsIgnoreCase("REJECTED")){
    	//	tmpQuery1 = "value.eventValue.loadUid";
    	//	tmpQuery2 = "value.eventValue.loadStatus";
    		
    //	}else if((ServiceRequestTaskColMatch == true)  && loadStatus.equalsIgnoreCase("FAILED")){
    //		tmpQuery1 = "value.failedItems.item.taskCode";
    //		tmpQuery2 = "value.loadStatus";
    //	}else{
    //		tmpQuery1 = "value.loadUid";
    //		tmpQuery2 = "value.loadStatus";
    //	}
    	
    	
    	
    	@SuppressWarnings("deprecation")
        DB db = mongoClient.getDB("gehc_ic_" + glblEnvironment + "_us_mgo_event_" + glblChannel + "_01");

    	DBCollection table = db.getCollection("ServiceRequestApi." + dynamicCollection);

        
         BasicDBObject andQuery = new BasicDBObject();
         List<BasicDBObject> obj = new ArrayList<BasicDBObject>();
        
         obj.add(new BasicDBObject(tmpQuery1, dynamicParam));
         obj.add(new BasicDBObject(tmpQuery2, loadStatus));
         obj.add(new BasicDBObject(tmpQuery3, dynamicCollection));
         obj.add(new BasicDBObject(tmpQuery4, "ServiceRequest.API"));
         andQuery.put("$and", obj);
         
         DBCursor cursor;
         boolean recordFound = false;
         
         //Will wait a maximum of 15 seconds before continuing
         for(int i=0; i < 15; i++){
        	 
	    	 cursor = table.find(andQuery);
	    	 
	    	 int DocumentsReturned = cursor.count();
	    	 			
	    	 if(DocumentsReturned == 1){
	    		 recordFound = true;
	    		 i = 15;
	    	 }else{
	    		 Thread.sleep(1000);
	    	 }
         }
         
         System.out.println("Mongo Query :" + andQuery);
         
         if(recordFound == true){
        	 return true;
         }else{
        	 return false;
         }
        
	}
    
	public static void connectSQL(String environment, String channel) throws Exception{
		
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://localhost:21434;databaseName=gehc_ic_" + environment + "_us_mdb_maint_" + channel + "_01";
        con = DriverManager.getConnection(url, userName, password);
	}
	
	public static boolean executeSQLQuery (String customQuery, int expectedCount) throws Exception{
		
		int count = 0;
		
		stmt = con.createStatement();
		result = stmt.executeQuery(customQuery);
		
	if(result!=null){
		while (result.next()){
            count++;
        }
	}
	
    System.out.println("SQL Query :" + customQuery);

		
		if(count == expectedCount){
			//Thread.sleep(1000);
			return true;
		}else{
			//Thread.sleep(1000);
			return false;
		}
		
	}
	
	public static void KarateSleep(int seconds) throws Exception{
		
		long mili = TimeUnit.SECONDS.toMillis(seconds);

		Thread.sleep(mili);
	}
	
	public static String returnDate(int addOrSubtractDays, int addOrSubtractYears) throws Exception{
		
		
		 Date curDate = new Date();
		 SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		 String DateToStr = format.format(curDate);
		 Calendar cal = Calendar.getInstance();
		 cal.setTime(format.parse(DateToStr));
		 
		 if(addOrSubtractDays != 0)  cal.add(Calendar.DATE, addOrSubtractDays);
		 if(addOrSubtractYears != 0)  cal.add(Calendar.YEAR, addOrSubtractYears);
		 

		 //use below code if restrictions exist against weekend dates
		 //if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY || cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
			// cal.add(Calendar.DATE, 3);
		 //}
		 
		 DateToStr = format.format(cal.getTime());
		 return DateToStr;
		
	}
}

/*

JsonPath reference https://github.com/json-path/JsonPath#path-examples, http://jsonpath.herokuapp.com/?path=$..*

 */

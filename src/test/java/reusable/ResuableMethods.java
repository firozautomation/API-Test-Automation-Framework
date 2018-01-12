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

import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;
import com.mongodb.MongoCredential;
import com.mongodb.ServerAddress;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;



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
	public static String ar[];
	
	public static String glblServiceRequest, glblTaskCode, glblAssetId, glblSourceSystem, glblCountry, glblSrid, glblTaskid;
	public static int AssetNumber;

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
    	
    	Gson gson = new GsonBuilder().setPrettyPrinting().create();
	    JsonParser jp = new JsonParser();
    	
    	String dynamicCollection = "";
    	String tmpQuery1 = "";
    	String tmpQuery2 = "";
    	String tmpQuery3 = "category";
    	String tmpQuery4 = "source";
    	
    	boolean ServiceRequestColMatch = Pattern.matches("(?i).*service.*request.*", collection); 
    	boolean ServiceRequestTaskColMatch = Pattern.matches("(?i).*task.*", collection); 
    	boolean ServiceRequestTaskGetTaskIdColMatch = Pattern.matches("(?i).*TaskId.*", collection); 
    	boolean ServiceRequestTaskGetSRIdColMatch = Pattern.matches("(?i).*srId.*", collection); 
    	boolean ServiceRequestPartsColMatch = Pattern.matches("(?i).*part.*", collection); 
    	boolean ServiceRequestTimesheetColMatch = Pattern.matches("(?i).*timesheet.*", collection); 
    	boolean ServiceRequestPerformanceTest = Pattern.matches("(?i).*performance.*", collection); 
    	boolean ServiceRequestAssetColMatch = Pattern.matches("(?i).*asset.*", collection); 

    	
    	if(ServiceRequestColMatch == true){
    		dynamicCollection = "ServiceRequest";
    	}else if(ServiceRequestTaskColMatch == true){
    		dynamicCollection = "Task";
    	}else if (ServiceRequestPartsColMatch == true){
    		dynamicCollection = "Part";
    	}else if(ServiceRequestTimesheetColMatch == true){
    		dynamicCollection = "Timesheet";
    	}else if(ServiceRequestAssetColMatch == true){
    		dynamicCollection = "Asset";	
    	}else{
    		dynamicCollection = "unable to get valid collection";
    	}
    	
    	
		tmpQuery1 = "value.loadUid";
		tmpQuery2 = "value.loadStatus";
  
    	
    	
    	
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
	    		 
	    		 if(ServiceRequestPerformanceTest == true){
	    			 DBObject mapObj = cursor.next();
	    			 String tmp = ((DBObject)mapObj.get("value")).get("metrics").toString();
	    			 
	    			 JsonElement je = jp.parse(tmp.toString());
	    	    	 String prettyJsonString = gson.toJson(je);
	    	    	 
	    	    	 System.out.println(collection + " Metrics are: \n" + prettyJsonString);
	    		 };
	    		 
	    		 if(ServiceRequestAssetColMatch == true){
	    			 DBObject mapObj = cursor.next();
	    			 BasicDBList assetList = (BasicDBList) ((DBObject)mapObj.get("value")).get("content");
	    			 
	                 BasicDBObject idObj = (BasicDBObject) assetList.get(0);
	                 AssetNumber = idObj.getInt("id");
	    		 };
	    		 
	    		 if(ServiceRequestTaskGetTaskIdColMatch == true){
	    			 DBObject mapObj = cursor.next();
	    			 BasicDBList taskList = (BasicDBList) ((DBObject)mapObj.get("value")).get("content");
	    			 
	                 BasicDBObject compositeTaskObj = (BasicDBObject) taskList.get(0);
	                 glblTaskid = compositeTaskObj.getString("taskId");
	    		 };
	    		 
	    		 if(ServiceRequestTaskGetSRIdColMatch == true){
	    			 DBObject mapObj = cursor.next();
	    			 BasicDBList taskList = (BasicDBList) ((DBObject)mapObj.get("value")).get("content");
	    			 
	                 BasicDBObject compositeTaskObj = (BasicDBObject) taskList.get(0);
	                 glblSrid = compositeTaskObj.getString("srId");
	    		 };
	    		 
	    		 
	    		 
	    		 recordFound = true;
	    		 i = 15;
	    	 }else{
	    		 Thread.sleep(1000);
	    	 }
         }
         
         System.out.println("Mongo Query :" + andQuery + "\n");
         
         if(recordFound == true){
        	 return true;
         }else{
        	 return false;
         }
        
	}
    
    public static String retrieveGlobalsrId(){
    	
    	return glblSrid;
    }
    
    public static String retrieveGlobaltaskId(){
    	
    	return glblTaskid;
    }
    
    public static int retrieveAssetNumber(){
    	
    	return AssetNumber;
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
	
	
    System.out.println("SQL Query :" + customQuery + "\n");

		
		if(count == expectedCount){
			//Thread.sleep(1000);
			return true;
		}else{
			//Thread.sleep(1000);
			return false;
		}
		
	}
	
	public static boolean executeSQLQueryForExistingTasks () throws Exception{
		
		
		stmt = con.createStatement();
		result = stmt.executeQuery("SELECT Distinct TOP 5 "
				+ "ServiceRequestCode, AssetTblAssetId, SourceSystemCode, Country, TaskCode "
				+ "FROM dbo.sr_refresh_task_view "
				+ "WHERE LEN(AssetTblAssetId) < 100 "
				+ "And LEN(ServiceRequestCode) < 100 "
				+ "AND ServiceRequestCode NOT Like '%:%' "
				+ "AND AssetTblAssetId NOT Like '%:%' "
				+ "AND TaskCode NOT Like '%:%';");
		
		ar = new String[25];
		int num = 0;
        
		
		if(result!=null){
          while (result.next()){
        	  
        	  ar[num]= result.getString("ServiceRequestCode");
        	  num++;
        	  
              ar[num] =  result.getString("AssetTblAssetId");
              num++;
              
              ar[num] =  result.getString("SourceSystemCode");
              num++;
              
              ar[num] =  result.getString("Country");
              num++;
              
              ar[num] =  result.getString("TaskCode");
              num++;              
          }
          System.out.println("SQL Query for Tasks Executed \n");
          return true;
      }else{
    	  return false;
      }
	}
	
	public static String returnResultsForPartsSetup(int recrord, String column){
		
		String localreturnValue = null;
		
		switch(recrord){
		
		case 1:
			
			switch(column){
			
			case "ServiceRequestCode":
				localreturnValue = ar[0];
				break;
				
			case "AssetTblAssetId":
				localreturnValue = ar[1];
				break;
				
			case "SourceSystemCode":
				localreturnValue = ar[2];
				break;
				
			case "Country":
				localreturnValue = ar[3];
				break;
				
			case "TaskCode":
				localreturnValue = ar[4];
				break;
				
			default:
				System.out.println("Unknown or missing column");
				localreturnValue = null;
				break;
			}
			
			break;
		
		case 2:
			
			switch(column){
			
			case "ServiceRequestCode":
				localreturnValue = ar[5];
				break;
				
			case "AssetTblAssetId":
				localreturnValue = ar[6];
				break;
				
			case "SourceSystemCode":
				localreturnValue = ar[7];
				break;
				
			case "Country":
				localreturnValue = ar[8];
				break;
				
			case "TaskCode":
				localreturnValue = ar[9];
				break;
				
			default:
				System.out.println("Unknown or missing column");
				localreturnValue = null;
				break;
			}
			
			break;
			
		case 3:
			
			switch(column){
			
			case "ServiceRequestCode":
				localreturnValue = ar[10];
				break;
				
			case "AssetTblAssetId":
				localreturnValue = ar[11];
				break;
				
			case "SourceSystemCode":
				localreturnValue = ar[12];
				break;
				
			case "Country":
				localreturnValue = ar[13];
				break;
				
			case "TaskCode":
				localreturnValue = ar[14];
				break;	
				
			default:
				System.out.println("Unknown or missing column");
				localreturnValue = null;
				break;
			}
			break;
			
		case 4:
			
			switch(column){
			
			case "ServiceRequestCode":
				localreturnValue = ar[15];
				break;
				
			case "AssetTblAssetId":
				localreturnValue = ar[16];
				break;
				
			case "SourceSystemCode":
				localreturnValue = ar[17];
				break;
				
			case "Country":
				localreturnValue = ar[18];
				break;
				
			case "TaskCode":
				localreturnValue = ar[19];
				break;	
				
			default:
				System.out.println("Unknown or missing column");
				localreturnValue = null;
				break;
			}
			
			break;
			
		case 5:
			
			switch(column){
			
			case "ServiceRequestCode":
				localreturnValue = ar[20];
				break;
				
			case "AssetTblAssetId":
				localreturnValue = ar[21];
				break;
				
			case "SourceSystemCode":
				localreturnValue = ar[22];
				break;
				
			case "Country":
				localreturnValue = ar[23];
				break;
				
			case "TaskCode":
				localreturnValue = ar[24];
				break;	
				
			default:
				System.out.println("Unknown or missing column \n");
				localreturnValue = null;
				break;
			}
			break;
		
		default:
				System.out.println("Unknown or missing record \n");
				localreturnValue = null;
			break;
		}		
		return localreturnValue;
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
	
	public static String createTestData(String service, int numberOfRecords, int staticRand, int NumberOfFailures, int NumberOfRejections) throws Exception{
		
    	boolean ServiceRequestService = Pattern.matches("(?i).*service.*request.*", service); 
    	boolean ServiceRequestTask = Pattern.matches("(?i).*task.*", service); 
    	boolean ServiceRequestParts = Pattern.matches("(?i).*part.*", service); 
    	boolean ServiceRequestTimesheet = Pattern.matches("(?i).*timesheet.*", service);
    	boolean Insert = Pattern.matches("(?i).*insert.*", service);
    	boolean Update = Pattern.matches("(?i).*update.*", service);
    	boolean ServiceRequestFailed = Pattern.matches("(?i).*failed.*", service);
    	boolean ServiceRequestRejected = Pattern.matches("(?i).*rejected.*", service);
    	boolean skipRejectedCondition = false;
    	
		
	    //GET Dates
		String  todaysDate = returnDate(0,0);
		String tomorrowsDate = returnDate(1,0);
		String yesterdaysDate = returnDate(-1,0);
		String invalidDate = returnDate(0,-1000);
		
		int rand = 0;

		
		JSONObject objParent = new JSONObject();
	    JSONObject objChild = null;
	    JSONArray list = new JSONArray();
	    
	    for(int i = 1; i <= numberOfRecords; i++){

	    	objChild = new JSONObject();
	    	rand = generateRandomNumber();
	    	
	    	if(ServiceRequestService == true){
	    		String assetAvailability = "Up";
	    		String serviceRequestCode = "";
	    		String problem = "";
	    		String tmpCountry = glblCountry;
	    		
	    		if(NumberOfFailures == 0){
	    			skipRejectedCondition = false;
	    		}
	    		
	    		if((ServiceRequestFailed == true) && NumberOfFailures > 0){
	    			assetAvailability = "FailThisRecord";
	    			NumberOfFailures--;
	    			skipRejectedCondition = true;
	    		}
	    		
	    				
	    		if(((ServiceRequestRejected == true) && NumberOfRejections > 0) && skipRejectedCondition == false){
	    			tmpCountry = "NK";
	    			NumberOfRejections--;
	    		}
	    		
	    		if(Update == true){
	    			serviceRequestCode = glblServiceRequest;
	    			problem = "Update" + rand;
	    		}
	    		
	    		if(Insert == true){
	    			serviceRequestCode = "PerformanceTestUsingKarate" + rand;
	    			problem = "Insert";
	    		}
	    		
	    		
		    	objChild.put("assetId",glblAssetId);
		    	objChild.put("country",tmpCountry);
		    	objChild.put("serviceRequestCode",serviceRequestCode);
		    	objChild.put("serviceRequestTypeCode","servicerequestcorrective");
		    	objChild.put("serviceRequestStatusCode","Started");
		    	objChild.put("requester",staticRand);
		    	objChild.put("problem",problem);
		    	objChild.put("submissionTimestamp", todaysDate + "T15:53:51.597Z");
		    	objChild.put("sourceUpdateDate",todaysDate + "T15:53:51.597Z");
		    	objChild.put("completionDate",tomorrowsDate + "T15:53:51.597Z");
		    	objChild.put("dueDate",tomorrowsDate + "T15:53:51.597Z");
		    	objChild.put("availabilityDate", tomorrowsDate + "T15:53:51.597Z");
		    	objChild.put("sourceSystemCode",glblSourceSystem);
		    	objChild.put("remotely","0");
		    	objChild.put("assetAvailability",assetAvailability);
		    	objChild.put("facilityCode","US_294629");
		    	objChild.put("startDate", yesterdaysDate + "T15:53:51.597Z");
		    	objChild.put("requestedTimestamp",todaysDate + "T15:53:51.597Z");
		    	objChild.put("sourceDescription","sourceDescription");
		    	objChild.put("subSourceDescription","subSourceDescription");
		    	objChild.put("availabilityAtAssetLevel","Up");
	    		
	    	}else if(ServiceRequestTask == true){
	    		
	    		
	    		String assetAvailability = "Up";
	    		String taskCode = "";
	    		String cause = "";
	    		String tmpCountry = glblCountry;
	    		
	    		if(NumberOfFailures == 0){
	    			skipRejectedCondition = false;
	    		}
	    		
	    		if((ServiceRequestFailed == true) && NumberOfFailures > 0){
	    			assetAvailability = "FailThisRecord";
	    			NumberOfFailures--;
	    			skipRejectedCondition = true;
	    		}
	    		
	    				
	    		if(((ServiceRequestRejected == true) && NumberOfRejections > 0) && skipRejectedCondition == false){
	    			tmpCountry = "NK";
	    			NumberOfRejections--;
	    		}
	    		
	    		if(Update == true){
	    			taskCode = glblTaskCode;
	    			cause = "Update" + rand;
	    		}
	    		
	    		if(Insert == true){
	    			taskCode = "Task-PerformanceTestUsingKarate" + rand;
	    			cause = "Insert";
	    		}
	    		
	    		
		    	objChild.put("country",tmpCountry);
		    	objChild.put("taskStatusCode","Closed");
		    	objChild.put("facilityCode","US_203532");
		    	objChild.put("serviceRequestCode",glblServiceRequest);
		    	objChild.put("sourceSystemCode",glblSourceSystem);
		    	objChild.put("taskCode",taskCode);
		    	objChild.put("taskTypeCode","taskfesupport");
		    	objChild.put("cause",cause);
		    	objChild.put("completionDate",yesterdaysDate + "T15:53:51.597Z");
		    	objChild.put("completionStatus","Up");
		    	objChild.put("correctiveAction","string");
		    	objChild.put("verification","string");
		    	objChild.put("testResult","string");
		    	objChild.put("fieldEngineer","string");
		    	objChild.put("servicedBy", staticRand);
		    	objChild.put("startDate",todaysDate + "T15:53:51.597Z");
		    	objChild.put("startStatus","Down");
		    	objChild.put("poNumber","po 234");
		    	objChild.put("problemCode","string");
		    	objChild.put("fieldEngineerTimestamp",todaysDate + "T15:53:51.597Z");
		    	objChild.put("coveredHours",10);
		    	objChild.put("overtimeHours",0);
		    	objChild.put("doubleOvertimeHours",0);
		    	objChild.put("coveredTravelHours",0);
		    	objChild.put("overtimeTravelHours",0);
		    	objChild.put("doubleOvertimeTravelHours",0);
		    	objChild.put("sourceUpdateDate",todaysDate + "T15:53:51.597Z");
	    		objChild.put("assetId",glblAssetId);
		    	objChild.put("plannedStartDate",todaysDate + "T15:53:51.597Z");
		    	objChild.put("availabilityAtAssetLevel",assetAvailability);
		    	objChild.put("assetAvailability","Up");
	    		
	    		
	    	}else if(ServiceRequestParts == true){
	    		
	    		String reference = "some new or existing part";
	    		String partConsumptionId = "";
	    		//String description = staticRand;
	    		String tmpCountry = glblCountry;
	    		
	    		if(NumberOfFailures == 0){
	    			skipRejectedCondition = false;
	    		}
	    		
	    		if((ServiceRequestFailed == true) && NumberOfFailures > 0){
	    			reference = "";
	    			NumberOfFailures--;
	    			skipRejectedCondition = true;
	    		}
	    		
	    				
	    		if(((ServiceRequestRejected == true) && NumberOfRejections > 0) && skipRejectedCondition == false){
	    			tmpCountry = "NK";
	    			NumberOfRejections--;
	    		}
	    		
	    		
	    		if(Insert == true){
	    			partConsumptionId = "Part-PerformanceTestUsingKarate" + rand;
	    			//description = "Insert";
	    		}
	    		

		    	objChild.put("partConsumptionSourceSystemId",partConsumptionId);
		    	objChild.put("taskCode",glblTaskCode);
	    		objChild.put("assetId",glblAssetId);
		    	objChild.put("serviceRequestCode",glblServiceRequest);
		    	objChild.put("facilityCode","US_203532");
		    	objChild.put("description","some description");
		    	objChild.put("reference",reference);
		    	objChild.put("quantity",43);
		    	objChild.put("price",5.25);
		    	objChild.put("sourceUpdateDate",todaysDate + "T15:53:51.597Z");
		    	objChild.put("country",tmpCountry);
		    	objChild.put("startDate",todaysDate + "T15:53:51.597Z");
		    	objChild.put("sourceSystemCode",glblSourceSystem);
		    	objChild.put("source",staticRand);
		    	objChild.put("destination","service depot");
	    		
	    	}else if(ServiceRequestTimesheet == true){
	    		
	    		String code = "";
	    		//String projectName = "";
	    		String startDate = todaysDate + "T15:53:51.597Z";
	    		String tmpCountry = glblCountry;
	    		
	    		if(NumberOfFailures == 0){
	    			skipRejectedCondition = false;
	    		}
	    		
	    		if((ServiceRequestFailed == true) && NumberOfFailures > 0){
	    			startDate = invalidDate + "T15:53:51.597Z";
	    			NumberOfFailures--;
	    			skipRejectedCondition = true;
	    		}
	    		
	    				
	    		if(((ServiceRequestRejected == true) && NumberOfRejections > 0) && skipRejectedCondition == false){
	    			tmpCountry = "NK";
	    			NumberOfRejections--;
	    		}
	    		
	    		
	    		if(Insert == true){
	    			code = "timesheet-PerformanceTestUsingKarate" + rand;
	    			//projectName = "Insert";
	    		}
	    		

		    	objChild.put("code",code);
		    	objChild.put("taskCode",glblTaskCode);
	    		objChild.put("assetId",glblAssetId);
		    	objChild.put("serviceRequestCode",glblServiceRequest);
		    	objChild.put("facilityCode","US_203532");
		    	objChild.put("projectName",staticRand);
		    	objChild.put("startDate",startDate);
		    	objChild.put("completionDate",todaysDate + "T15:53:51.597Z");
		    	objChild.put("coveredHours",1.5);
		    	objChild.put("coveredTravelHours",5.25);
		    	objChild.put("overtimeHours",10);
		    	objChild.put("overtimeTravelHours",2);
		    	objChild.put("doubleOvertimeHours",45);
		    	objChild.put("doubleOvertimeTravelHours",4);
		    	objChild.put("totalHours",100);
		    	objChild.put("sourceUpdateDate",todaysDate + "T15:53:51.597Z");
		    	objChild.put("country",tmpCountry);
		    	objChild.put("sourceSystemCode",glblSourceSystem);
		    	
	    	}
	    	
		    	
			    list.add(objChild);
			    
			    objParent.put("content", list);
		    
	    }
	    
	    Gson gson = new GsonBuilder().setPrettyPrinting().create();
	    JsonParser jp = new JsonParser();
	    JsonElement je = jp.parse(objParent.toString());
	    String prettyJsonString = gson.toJson(je);
	    
	    //System.out.println("Ugly Format: " + objParent.toJSONString() + "\n");
	    //System.out.println("Pretty Format: \n" + prettyJsonString);
	    
	    return prettyJsonString;
		
	}
	
	public static void setGlobalPerformanceTestData(String serviceRequestCode,
			String sourceSystemCode, String taskCode, String assetTblAssetId, String country){
		
		glblServiceRequest = serviceRequestCode;
		glblSourceSystem = sourceSystemCode;
		glblTaskCode = taskCode;
		glblAssetId	= assetTblAssetId;
		glblCountry = country;
		
	}
	

}

/*

JsonPath reference https://github.com/json-path/JsonPath#path-examples, http://jsonpath.herokuapp.com/?path=$..*

 */

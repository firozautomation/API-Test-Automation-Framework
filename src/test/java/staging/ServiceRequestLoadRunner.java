package staging;

import org.junit.runner.RunWith;
import com.intuit.karate.junit4.Karate;

import cucumber.api.CucumberOptions;

@RunWith(Karate.class)
@CucumberOptions(features = "classpath:testsuite/load/Mongo.feature")

public class ServiceRequestLoadRunner {

}

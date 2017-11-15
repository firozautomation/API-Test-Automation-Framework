package testsuite.A.smoke.post;

import org.junit.runner.RunWith;
import com.intuit.karate.junit4.Karate;

import cucumber.api.CucumberOptions;

@RunWith(Karate.class)
@CucumberOptions(features = "classpath:testsuite/A/smoke/post/Service Request Timesheets Verification Smoke Test.feature")

public class ServiceRequestPostRunner {

}

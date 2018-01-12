package testsuite.A.smoke.post;

import org.junit.runner.RunWith;
import com.intuit.karate.junit4.Karate;

import cucumber.api.CucumberOptions;

@RunWith(Karate.class)
@CucumberOptions(
		//plugin = {"pretty", "html:target/html/"},
		features = "classpath:testsuite/A/smoke/post/Service Request Parts POST Smoke Test.feature"
		)

public class ServiceRequestPostRunner {

}

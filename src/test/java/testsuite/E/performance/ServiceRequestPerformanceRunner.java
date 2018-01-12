package testsuite.E.performance;

import org.junit.runner.RunWith;
import com.intuit.karate.junit4.Karate;

import cucumber.api.CucumberOptions;

@RunWith(Karate.class)
@CucumberOptions(features = "classpath:testsuite/E/performance/Service Request Task Performance Test.feature")

public class ServiceRequestPerformanceRunner {

}

package testsuite.D.bulk;

import org.junit.runner.RunWith;
import com.intuit.karate.junit4.Karate;

import cucumber.api.CucumberOptions;

import com.intuit.karate.cucumber.CucumberRunner;
import com.intuit.karate.cucumber.KarateStats;
import cucumber.api.CucumberOptions;
import static org.junit.Assert.assertTrue;
import org.junit.Test;

//@CucumberOptions(tags = {"~@ignore"})
@RunWith(Karate.class)
@CucumberOptions(features = "classpath:testsuite/D/bulk/Service Request Parts POST Bulk Scenarios.feature")

public class ServiceRequestPostBulkRunner {
	
	 //@Test
	    //public void testParallel() {
	      //  KarateStats stats = CucumberRunner.parallel(getClass(), 2, "target/surefire-reports");
	    //    assertTrue("scenarios failed", stats.getFailCount() == 0);
	   // }


}

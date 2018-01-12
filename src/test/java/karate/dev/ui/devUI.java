package karate.dev.ui;

import com.intuit.karate.ui.App;
import org.junit.Test;

public class devUI {
	
	@Test
    public void testApp() {
        App.run("src/test/java/testsuite/A/smoke/post/Service Request POST Smoke Test.feature", "dev");
    } 

}

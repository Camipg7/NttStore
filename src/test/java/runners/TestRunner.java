package runners;

import com.intuit.karate.junit5.Karate;

public class TestRunner {

    @Karate.Test
    Karate ejecutarRegresion() {
        return Karate.run("classpath:features/productStore.feature");
    }
}

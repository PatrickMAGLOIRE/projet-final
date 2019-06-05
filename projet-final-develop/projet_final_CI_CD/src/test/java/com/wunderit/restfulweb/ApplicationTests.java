package com.wunderit.restfulweb;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import static org.junit.Assert.assertEquals;

@RunWith(SpringRunner.class)
@SpringBootTest
public class ApplicationTests {

    @Test
    public void contextLoads() {
    }

    @Test
    public void sum_with3numbersok() {
        System.out.println("Test1");

        assertEquals(3, 3);
    }
    @Test
    public void sum_with3numbersko() {
        System.out.println("Test2");

        assertEquals(3, 2);
    }
}

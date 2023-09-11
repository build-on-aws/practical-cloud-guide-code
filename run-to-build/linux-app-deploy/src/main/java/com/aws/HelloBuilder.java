package com.aws;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class HelloBuilder {

	public static void main(String[] args) {
		SpringApplication.run(HelloBuilder.class, args);
	}
	
	@RestController
    public class HelloWorldController {
	
	   @GetMapping(path="/")
	   public String sayHello() {
	      DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm:ss");  
	      LocalDateTime now = LocalDateTime.now();  
	      return "Hello Builder! The server time is: "  + dtf.format(now) ;
	   }
	}

}

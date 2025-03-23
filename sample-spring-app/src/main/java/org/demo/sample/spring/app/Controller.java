package org.demo.sample.spring.app;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.GetMapping;


@RestController
public class Controller {

	// One syntax to implement a
	// GET method
	@GetMapping("/")
	public String home()
	{
		String str
			= "<html><body><font color=\"green\">"
			+ "<h1>WELCOME To Demo Project</h1>"
			+ "</font></body></html>";
		return str;
	}

	// Another syntax to implement a
	// GET method
	@RequestMapping(
		method = { RequestMethod.GET },
		value = { "/path" })

	public String info()
	{
		String str2
			= "<html><body><font color=\"green\">"
			+ "<h2>Testing is path"
			+ "</h2></font></body></html>";
		return str2;
	}
}

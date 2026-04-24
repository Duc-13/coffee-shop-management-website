package com.polycoffee.Util;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

public class ParamUtil {
	//Trả về giá trị kiểu String
	public static String getString(HttpServletRequest request, String name) {
		try {
			return request.getParameter(name);
		} catch (Exception e) {
			// TODO: handle exception
			return null;
		}
	}
	//Trả về giá trị kiểu int
	public static int getInt(HttpServletRequest request, String name) {
		try {
			return Integer.parseInt(request.getParameter(name));
		} catch (Exception e) {
			// TODO: handle exception
			return 0;
		}
		
	}
	//Trả về giá trị kiểu Date
	public static Date getDate(HttpServletRequest request, String name, String pattern) {
		try {
	        String value = request.getParameter(name);
	        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
	        return sdf.parse(value);
	    } catch (Exception e) {
	        return null; 
	    }
	}
}




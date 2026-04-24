package com.polycoffee.Util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {
	// Chuyển String → Date
    public static Date toDate(String value, String pattern) {
        try {
            if (value == null || value.isEmpty()) {
                return null;
            }
            SimpleDateFormat sdf = new SimpleDateFormat(pattern);
            return sdf.parse(value);
        } catch (Exception e) {
            return null; // có thể trả về new Date() nếu muốn ngày hiện tại
        }
    }
 // Chuyển Date → String
    public static String toString(Date date, String pattern) {
        if (date == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
        return sdf.format(date);
    }
}

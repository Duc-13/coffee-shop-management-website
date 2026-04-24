package com.polycoffee.Util;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class Mailer {
    // Hào nhớ kiểm tra kỹ Email và App Password (16 ký tự) nhé
    private static final String username = "haobnats00832@fpt.edu.vn"; 
    private static final String password = "uxmi mcmz biye uenj\r\n"
    		+ ""; 

    public static void send(String to, String subject, String body) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        
        // ĐÂY LÀ 2 DÒNG QUAN TRỌNG ĐỂ FIX LỖI "SOCKET TO TLS"
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(username));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setText(body);
        
        Transport.send(message);
    }
}
package com.polycoffee.Entity;

import java.util.Date;

public class Bill {
	private int billsId;
	private String code;
	private Date createdAt;
	private int total;
	private int status;
	private int usersId;
	private String fullName;
	private String payment_Method;



	public String getPayment_Method() {
		return payment_Method;
	}

	public void setPayment_Method(String payment_Method) {
		this.payment_Method = payment_Method;
	}

	public Bill(String payment_Method) {
		this.payment_Method = payment_Method;
	}
	public Bill() {}

	public Bill(int billsId, String code, Date createdAt, int total, int status, int usersId, String fullName) {
		this.billsId = billsId;
		this.code = code;
		this.createdAt = createdAt;
		this.total = total;
		this.status = status;
		this.usersId = usersId;
		this.fullName = fullName;
	}

	public int getBillsId() {
		return billsId;
	}

	public void setBillsId(int billsId) {
		this.billsId = billsId;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public int getUsersId() {
		return usersId;
	}

	public void setUsersId(int usersId) {
		this.usersId = usersId;
	}
}
package com.polycoffee.Entity;

import java.sql.Timestamp;

public class User {

	private int usersId;
	private String email;
	private String password;
	private String fullName;
	private String phone;
	private boolean active;
	private int role; // 0=ADMIN, 1=STAFF, 2=CUSTOMER

	// ── Lockout fields ──────────────────────────────────────
	private int failedAttempts;   // Số lần đăng nhập sai liên tiếp
	private Timestamp lockedUntil; // NULL = không khóa; có giá trị = khóa đến lúc này
	// ────────────────────────────────────────────────────────

	public User() {}

	public User(int usersId, String email, String password, String fullName,
				String phone, boolean active, int role) {
		this.usersId  = usersId;
		this.email    = email;
		this.password = password;
		this.fullName = fullName;
		this.phone    = phone;
		this.active   = active;
		this.role     = role;
	}



	public int getUsersId()              { return usersId; }
	public void setUsersId(int usersId)  { this.usersId = usersId; }

	public String getEmail()             { return email; }
	public void setEmail(String email)   { this.email = email; }

	public String getPassword()                  { return password; }
	public void setPassword(String password)     { this.password = password; }

	public String getFullName()                  { return fullName; }
	public void setFullName(String fullName)     { this.fullName = fullName; }

	public String getPhone()             { return phone; }
	public void setPhone(String phone)   { this.phone = phone; }

	public boolean isActive()            { return active; }
	public void setActive(boolean active){ this.active = active; }

	public int getRole()                 { return role; }
	public void setRole(int role)        { this.role = role; }



	public int getFailedAttempts()                       { return failedAttempts; }
	public void setFailedAttempts(int failedAttempts)    { this.failedAttempts = failedAttempts; }

	public Timestamp getLockedUntil()                    { return lockedUntil; }
	public void setLockedUntil(Timestamp lockedUntil)    { this.lockedUntil = lockedUntil; }


	public boolean isCurrentlyLocked() {
		return lockedUntil != null
				&& lockedUntil.after(new java.util.Date());
	}


	public long getRemainingLockSeconds() {
		if (!isCurrentlyLocked()) return 0;
		return (lockedUntil.getTime() - System.currentTimeMillis()) / 1000;
	}
}
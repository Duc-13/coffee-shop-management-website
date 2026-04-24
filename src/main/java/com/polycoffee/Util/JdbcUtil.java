package com.polycoffee.Util;

import javax.sql.*;
import java.sql.*;

public class JdbcUtil {
	// Ensure databaseName is used instead of database if using newer drivers
	static String dburl = "jdbc:sqlserver://localhost:1433;databaseName=JAV202;encrypt=false;trustServerCertificate=true";
	static String username = "sa";
	static String password = "123456";

	static {
		try {
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}

	public static Connection getConnection() throws SQLException {
		return DriverManager.getConnection(dburl, username, password);
	}

	public static PreparedStatement getStmt(Connection conn, String sql, Object... values) throws SQLException {
		PreparedStatement stmt = sql.trim().startsWith("{")
				? conn.prepareCall(sql)
				: conn.prepareStatement(sql);

		for (int i = 0; i < values.length; i++) {
			stmt.setObject(i + 1, values[i]);
		}
		return stmt;
	}

	// Use this for INSERT, UPDATE, DELETE
	public static int executeUpdate(String sql, Object... values) {
		try (Connection conn = getConnection();
			 PreparedStatement stmt = getStmt(conn, sql, values)) {
			return stmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			return 0;
		}
	}

	// Use this for SELECT
	// Note: The caller must close the ResultSet/Statement/Connection or use a CachedRowSet
	public static ResultSet executeQuery(String sql, Object... values) throws SQLException {
		Connection conn = getConnection();
		PreparedStatement stmt = getStmt(conn, sql, values);
		return stmt.executeQuery();
	}
}
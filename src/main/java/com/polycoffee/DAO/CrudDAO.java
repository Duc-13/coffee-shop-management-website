package com.polycoffee.DAO;

import java.util.List;

public interface CrudDAO<T, ID> {

	List<T> findAll();

	T findById(ID id);

	int create(T entity);

	int update(T entity);

	int deleteById(ID id);
}
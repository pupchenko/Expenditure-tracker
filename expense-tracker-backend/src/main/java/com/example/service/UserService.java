package com.example.service;

import com.example.model.User;

import java.util.List;
import java.util.Optional;

public interface UserService {
    List<User> getUsers();

    Optional<User> save(User user);

    Optional<User> update(long id, User user);

    Optional<User> findById(long id);

    void delete(long id);
}

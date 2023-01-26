package com.example.service;

import com.example.model.User;
import com.example.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepo;

    public UserServiceImpl(UserRepository userRepo) {
        this.userRepo = userRepo;
    }

    @Override
    public List<User> getUsers() {
        return userRepo.findAll();
    }

    @Override
    public Optional<User> save(User user) {
        var userOptional = userRepo.findByUserName(user.getUserName());
        if (userOptional.isPresent()) {
            return Optional.empty();
        }
        return Optional.of(userRepo.save(user));
    }

    @Override
    public Optional<User> update(long id, User userDetails) {
        var userOptional = userRepo.findById(id);
        return userOptional.map(user -> {
            user.setUserName(userDetails.getUserName());
            return userRepo.save(user);
        });
    }

    @Override
    public Optional<User> findById(long id) {
        return userRepo.findById(id);
    }

    @Override
    public void delete(long id) {
        userRepo.findById(id).ifPresent(userRepo::delete);
    }
}

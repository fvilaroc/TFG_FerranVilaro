package com.tfg.backend.service;

import com.tfg.backend.domain.User;
import com.tfg.backend.persistance.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User getCurrentUser(String username) {
        return userRepository.findByUsername(username).
                orElseThrow(() -> new RuntimeException("User not found with username: " + username));
    }

    public User getUserById(Long id) {
        return userRepository.findById(id).
                orElseThrow(() -> new RuntimeException("User not found with id: " + id));
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
}

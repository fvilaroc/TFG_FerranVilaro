package com.tfg.backend.service;

import com.tfg.backend.domain.User;
import com.tfg.backend.persistance.UserRepository;
import com.tfg.backend.service.dto.UserDTO;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public UserDTO getCurrentUser(String username) {
        User user = userRepository.findByUsername(username).
                orElseThrow(() -> new RuntimeException("User not found with username: " + username));

        return toDTO(user);
    }

    public UserDTO getUserById(Long id) {
        User user = userRepository.findById(id).
                orElseThrow(() -> new RuntimeException("User not found with id: " + id));

        return toDTO(user);
    }

    public List<UserDTO> getAllUsers() {
        List<User> users = userRepository.findAll();

        return users.stream().map(this::toDTO).toList();
    }

    public void updateLoginStreak(User user) {
        LocalDate today = LocalDate.now();

        if (user.getLastLogin() == null) {
            user.setLastLogin(today);
            user.setStreak(1);
        } else if (user.getLastLogin().equals(today)) {
            return;
        } else if (user.getLastLogin().equals(today.minusDays(1))) {
            user.setStreak(user.getStreak() + 1);
            user.setLastLogin(today);
        } else {
            user.setStreak(1);
            user.setLastLogin(today);
        }

        userRepository.save(user);
    }

    public User getUserEntityByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found with username: " + username));
    }

    private UserDTO toDTO(User user) {
        return new UserDTO(
                user.getId(),
                user.getEmail(),
                user.getUsername(),
                user.getPoints(),
                user.getStreak(),
                user.getRoles()
        );
    }
}

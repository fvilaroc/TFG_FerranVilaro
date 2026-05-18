package com.tfg.backend.service;

import com.tfg.backend.domain.ERole;
import com.tfg.backend.domain.User;
import com.tfg.backend.persistance.UserRepository;
import com.tfg.backend.security.authentication.AuthenticationService;
import com.tfg.backend.service.dto.UpdateUsernameResponseDTO;
import com.tfg.backend.service.dto.UserDTO;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final UserMedalService userMedalService;

    public UserService(UserRepository userRepository, EmailService emailService, PasswordEncoder passwordEncoder, JwtService jwtService, UserMedalService userMedalService) {
        this.userRepository = userRepository;
        this.emailService = emailService;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.userMedalService = userMedalService;
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
            user.setPoints(user.getPoints() + 10);
        } else if (user.getLastLogin().equals(today)) {
            return;
        } else if (user.getLastLogin().equals(today.minusDays(1))) {
            user.setStreak(user.getStreak() + 1);
            user.setLastLogin(today);
            if(user.getStreak() >= 5) {
                user.setPoints(user.getPoints() + 50);
            }
            else {
                user.setPoints(user.getPoints() + (user.getStreak()*10));
            }
        } else {
            user.setStreak(1);
            user.setLastLogin(today);
            user.setPoints(user.getPoints() + 10);
        }

        userRepository.save(user);

        userMedalService.checkStreakMedals(user);
    }

    public User getUserEntityByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found with username: " + username));
    }

    public UpdateUsernameResponseDTO updateUserToPremium(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found with username: " + username));

        if (user.getRoles() == ERole.ADMIN) throw new RuntimeException("Admin cannot be premium");

        user.setRoles(ERole.PREMIUM);
        user.setPremiumStartDate(LocalDate.now());
        user.setPremiumEndDate(LocalDate.now().plusMonths(1));

        userRepository.save(user);

        emailService.sendPremiumUpgradeEmail(user.getEmail(), user.getUsername());

        userMedalService.checkPremiumMedal(user);

        return new UpdateUsernameResponseDTO(toDTO(user), jwtService.generateNewToken(user));
    }

    public void checkAndUpdatePremiumStatus(User user) {
        if (user.getRoles() == ERole.PREMIUM && user.getPremiumEndDate() != null) {
            if (LocalDate.now().isAfter(user.getPremiumEndDate())) {
                user.setRoles(ERole.FREE);
                userRepository.save(user);

                emailService.sendPremiumExpirationEmail(user.getEmail(), user.getUsername());
            }
        }
    }

    public void changeRoleToAdmin(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found with username: " + username));

        user.setRoles(ERole.ADMIN);
        userRepository.save(user);
    }

    public UpdateUsernameResponseDTO updateUsername (String username, String newUsername) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found with username: " + username));

        if(newUsername == null || newUsername.trim().isBlank())
            throw new RuntimeException("New username cannot be empty");

        newUsername = newUsername.trim();

        if(userRepository.existsByUsername(newUsername))
            throw new RuntimeException("Username already exists: " + newUsername);

        user.setUsername(newUsername);
        userRepository.save(user);

        return new UpdateUsernameResponseDTO(toDTO(user), jwtService.generateNewToken(user));
    }

    public void updateEmail (String username, String newEmail) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found with username: " + username));

        if(newEmail == null || newEmail.trim().isBlank())
            throw new RuntimeException("New email cannot be empty");

        newEmail = newEmail.trim().toLowerCase();

        if(!newEmail.contains("@"))
            throw new RuntimeException("Invalid email format: " + newEmail);

        if(userRepository.existsByEmail(newEmail))
            throw new RuntimeException("Email already exists: " + newEmail);

        user.setEmail(newEmail);
        userRepository.save(user);
    }

    public void updatePassword (String username, String currentPassword, String newPassword) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found with username: " + username));

        if(!passwordEncoder.matches(currentPassword, user.getPassword()))
            throw new RuntimeException("Current password is incorrect");

        if(newPassword == null || newPassword.trim().isBlank())
            throw new RuntimeException("New password cannot be empty");

        if(passwordEncoder.matches(newPassword, user.getPassword()))
            throw new RuntimeException("New password cannot be the same as the current password");

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    private UserDTO toDTO(User user) {
        return new UserDTO(
                user.getId(),
                user.getEmail(),
                user.getUsername(),
                user.getPoints(),
                user.getStreak(),
                user.getRoles(),
                user.getPremiumStartDate(),
                user.getPremiumEndDate()
        );
    }
}

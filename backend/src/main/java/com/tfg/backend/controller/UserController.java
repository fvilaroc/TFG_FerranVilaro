package com.tfg.backend.controller;

import com.tfg.backend.service.UserService;
import com.tfg.backend.service.dto.*;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/currentUser")
    public UserDTO getCurrentUser(Authentication authentication) {
        return userService.getCurrentUser(authentication.getName());
    }

    @GetMapping("/all")
    public List<UserDTO> getAllUsers() {
        return userService.getAllUsers();
    }

    @GetMapping("/{id}")
    public UserDTO getUserById(@PathVariable Long id) {
        return userService.getUserById(id);
    }

    @PatchMapping("/upgrade")
    public UpdateUsernameResponseDTO upgradeToPremium(Authentication authentication) {
        return userService.updateUserToPremium(authentication.getName());
    }

    @PatchMapping("/createAdmin/{username}")
    public void createAdmin(@PathVariable String username) {
        userService.changeRoleToAdmin(username);
    }

    @PatchMapping("/updateUsername")
    public UpdateUsernameResponseDTO updateUsername(Authentication authentication, @RequestBody UpdateUsernameRequestDTO username) {
        return userService.updateUsername(authentication.getName(), username.getNewUsername());
    }

    @PatchMapping("/updateEmail")
    public void updateEmail(Authentication authentication, @RequestBody UpdateEmailRequestDTO email) {
        userService.updateEmail(authentication.getName(), email.getNewEmail());
    }

    @PatchMapping("/updatePassword")
    public void updatePassword(Authentication authentication, @RequestBody UpdatePasswordRequestDTO password) {
        userService.updatePassword(authentication.getName(), password.getCurrentPassword(), password.getNewPassword());
    }
}

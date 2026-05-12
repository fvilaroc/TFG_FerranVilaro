package com.tfg.backend.controller;

import com.tfg.backend.service.*;
import com.tfg.backend.service.dto.*;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/medals")
public class UserMedalController {

    private final UserMedalService userMedalService;
    private final UserService userService;

    public UserMedalController(UserMedalService userMedalService, UserService userService) {
        this.userMedalService = userMedalService;
        this.userService = userService;
    }

    @GetMapping("/myMedals")
    public List<UserMedalDTO> getMyMedals(Authentication authentication) {
        UserDTO user = userService.getCurrentUser(authentication.getName());

        return userMedalService.getMedalsByUser(user);
    }
}

package com.tfg.backend.controller;

import com.tfg.backend.domain.User;
import com.tfg.backend.service.UserDanceProgressService;
import com.tfg.backend.service.UserService;
import com.tfg.backend.service.dto.UserDanceProgressDTO;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/progress")
public class UserDanceProgressController {

    private final UserDanceProgressService userDanceProgressService;
    private final UserService userService;

    public UserDanceProgressController(UserDanceProgressService userDanceProgressService, UserService userService) {
        this.userDanceProgressService = userDanceProgressService;
        this.userService = userService;
    }

    @GetMapping("/{danceId}")
    public UserDanceProgressDTO getProgressByDance(Authentication authentication,
                                                   @PathVariable Long danceId) {
        User user = userService.getUserEntityByUsername(authentication.getName());
        return userDanceProgressService.getUserDanceProgress(user.getId(), danceId);
    }

    @GetMapping("/all")
    public List<UserDanceProgressDTO> getAllProgress(Authentication authentication) {
        User user = userService.getUserEntityByUsername(authentication.getName());
        return userDanceProgressService.getAllProgressByUser(user.getId());
    }
}

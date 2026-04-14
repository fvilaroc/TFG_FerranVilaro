package com.tfg.backend.service.dto;

import com.tfg.backend.domain.ERole;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserDTO {
    private Long id;
    private String email;
    private String username;
    private int points;
    private int streak;
    private ERole role;

    public UserDTO() {}

    public UserDTO(Long id, String email, String username, int points, int streak, ERole role) {
        this.id = id;
        this.email = email;
        this.username = username;
        this.points = points;
        this.streak = streak;
        this.role = role;
    }
}

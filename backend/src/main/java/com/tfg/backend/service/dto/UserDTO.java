package com.tfg.backend.service.dto;

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

    public UserDTO() {}

    public UserDTO(Long id, String email, String username, int points, int streak) {
        this.id = id;
        this.email = email;
        this.username = username;
        this.points = points;
        this.streak = streak;
    }
}

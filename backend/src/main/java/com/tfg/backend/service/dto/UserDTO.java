package com.tfg.backend.service.dto;

import com.tfg.backend.domain.ERole;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class UserDTO {
    private Long id;
    private String email;
    private String username;
    private int points;
    private int streak;
    private ERole role;
    private LocalDate premiumStartDate;
    private LocalDate premiumEndDate;

    public UserDTO() {}

    public UserDTO(Long id, String email, String username, int points, int streak, ERole role, LocalDate premiumStartDate, LocalDate premiumEndDate) {
        this.id = id;
        this.email = email;
        this.username = username;
        this.points = points;
        this.streak = streak;
        this.role = role;
        this.premiumStartDate = premiumStartDate;
        this.premiumEndDate = premiumEndDate;
    }
}

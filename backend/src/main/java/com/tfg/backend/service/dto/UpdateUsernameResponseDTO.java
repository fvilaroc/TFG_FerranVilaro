package com.tfg.backend.service.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UpdateUsernameResponseDTO {
    private UserDTO user;
    private String newToken;

    public UpdateUsernameResponseDTO(UserDTO user, String newToken) {
        this.user = user;
        this.newToken = newToken;
    }
}

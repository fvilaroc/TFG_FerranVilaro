package com.tfg.backend.service.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserDanceProgressDTO {

    private Long id;
    private Long userId;
    private Long danceId;
    private int points;
    private int level;

    public UserDanceProgressDTO() {}
    
    public UserDanceProgressDTO(Long id, Long userId, Long danceId, int points, int level) {
        this.id = id;
        this.userId = userId;
        this.danceId = danceId;
        this.points = points;
        this.level = level;
    }
}

package com.tfg.backend.service.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DanceRankingDTO {
    private int position;
    private Long userId;
    private String username;
    private Long danceId;
    private int points;
    private int level;

    public DanceRankingDTO(int position, Long userId, String username, Long danceId, int points, int level) {
        this.position = position;
        this.userId = userId;
        this.username = username;
        this.danceId = danceId;
        this.points = points;
        this.level = level;
    }
}

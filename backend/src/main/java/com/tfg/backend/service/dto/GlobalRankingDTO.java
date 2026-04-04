package com.tfg.backend.service.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GlobalRankingDTO {
    private int position;
    private Long userId;
    private String username;
    private int points;

    public GlobalRankingDTO(int position, Long userId, String username, int points) {
        this.position = position;
        this.userId = userId;
        this.username = username;
        this.points = points;
    }
}

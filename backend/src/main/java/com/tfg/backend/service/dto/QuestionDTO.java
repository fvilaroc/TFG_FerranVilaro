package com.tfg.backend.service.dto;

import com.tfg.backend.domain.Difficulty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class QuestionDTO {

    private Long id;
    private String question;
    private String optionA;
    private String optionB;
    private String optionC;
    private String optionD;
    private int points;
    private Difficulty difficulty;
    private Long danceId;

    public QuestionDTO() {}

    public QuestionDTO(Long id, String question, String optionA, String optionB, String optionC, String optionD,
                       int points, Difficulty difficulty, Long danceId) {
        this.id = id;
        this.question = question;
        this.optionA = optionA;
        this.optionB = optionB;
        this.optionC = optionC;
        this.optionD = optionD;
        this.points = points;
        this.difficulty = difficulty;
        this.danceId = danceId;
    }
}

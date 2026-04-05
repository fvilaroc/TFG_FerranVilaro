package com.tfg.backend.service.dto;

public class AnswerResponseDTO {

    private boolean correct;
    private int points;

    public AnswerResponseDTO(boolean correct, int points) {
        this.correct = correct;
        this.points = points;
    }

    public boolean isCorrect() {
        return correct;
    }

    public int getPoints() {
        return points;
    }
}

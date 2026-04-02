package com.tfg.backend.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "questions")
@Getter
@Setter
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String question;

    @Column(nullable = false)
    private String correctAnswer;

    @Column(nullable = false)
    private String optionA;
    @Column(nullable = false)
    private String optionB;
    @Column(nullable = false)
    private String optionC;
    @Column(nullable = false)
    private String optionD;

    @Column(nullable = false)
    private int points;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Difficulty difficulty;

    @ManyToOne
    @JoinColumn(name = "dance_id", nullable = false)
    private Dance dance;

    public Question() {}

    public Question(String question, String correctAnswer, String answer1, String answer2, String answer3, String answer4, int points, Difficulty difficulty, Dance dance) {
        this.question = question;
        this.correctAnswer = correctAnswer;
        this.optionA = answer1;
        this.optionB = answer2;
        this.optionC = answer3;
        this.optionD = answer4;
        this.points = points;
        this.difficulty = difficulty;
        this.dance = dance;
    }
}

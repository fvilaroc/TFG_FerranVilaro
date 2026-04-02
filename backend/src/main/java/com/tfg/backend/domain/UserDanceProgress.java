package com.tfg.backend.domain;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "user_dance_progress",
        uniqueConstraints = {
            @UniqueConstraint(columnNames = {"user_id", "dance_id"})
        })
@Getter
@Setter
public class UserDanceProgress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user; // usuario al que pertenece el progreso

    @ManyToOne
    @JoinColumn(name = "dance_id")
    private Dance dance; // baile al que corresponde el progreso

    private int points = 0; // puntos de progreso en el baile

    public UserDanceProgress() {}

    public UserDanceProgress(User user, Dance dance, int points) {
        this.user = user;
        this.dance = dance;
        this.points = points;
    }

    @Transient
    public int getLevel() { // calcula el nivel que tiene el usuario en este baile basado en los puntos
        return (int) Math.sqrt(points / 10.0);
    }
}

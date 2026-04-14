package com.tfg.backend.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "user_TFG",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = "email"),
                @UniqueConstraint(columnNames = "username")
        })
@Getter
@Setter
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String email; // Correo electrónico como ID único
    private String username; // Nombre de usuario único

    private String password; // Contraseña del usuario
    private LocalDate dateOfBirth; // Fecha de nacimiento del usuario
    private LocalDate registrationDate; // Fecha de registro del usuario
    private int points = 0; // Puntos acumulados por el usuario
    private LocalDate lastLogin; // Fecha del último inicio de sesión del usuario
    private int streak = 0; // Racha de días consecutivos de inicio de sesión

    @Enumerated(EnumType.STRING)
    private ERole roles; //role que tiene el usuario

    @OneToMany(mappedBy = "user")
    private List<UserDanceProgress> progresses;

    public User() {}

    public User(String email, String username, String password, LocalDate dateOfBirth, LocalDate registrationDate, int points, LocalDate lastLogin, int streak, ERole role) {
        this.email = email;
        this.username = username;
        this.password = password;
        this.dateOfBirth = dateOfBirth;
        this.registrationDate = registrationDate;
        this.points = points;
        this.lastLogin = lastLogin;
        this.streak = streak;
        this.roles = role;
    }
}

package com.tfg.backend.domain;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "dances",
        uniqueConstraints =
            @UniqueConstraint(columnNames = "name"))
@Getter
@Setter
public class Dance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String region;

    @Column(length = 2000)
    private String description;

    private String videoUrl;

    @Column(columnDefinition = "TEXT")
    private String history;
    @Column(columnDefinition = "TEXT")
    private String origin;
    @Column(columnDefinition = "TEXT")
    private String clothing;
    @Column(columnDefinition = "TEXT")
    private String musicCharacteristics;
    @Column(columnDefinition = "TEXT")
    private String danceSteps;

    @OneToMany(mappedBy = "dance")
    private List<UserDanceProgress> progresses;

    public Dance() {}

    public Dance(String name, String region, String description, String videoUrl, String history, String origin, String clothing, String musicCharacteristics) {
        this.name = name;
        this.region = region;
        this.description = description;
        this.videoUrl = videoUrl;
        this.history = history;
        this.origin = origin;
        this.clothing = clothing;
        this.musicCharacteristics = musicCharacteristics;
    }
}
